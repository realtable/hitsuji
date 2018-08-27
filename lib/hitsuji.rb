require_relative 'transfer.rb'
require_relative 'subsystem.rb'

# The Hitsuji class is the interface to this module, and it contains
# all the functions you need. Examples using this class can be found in the
# descriptions of the class and instance methods below.
class Hitsuji
  # Creates a new system where all operations are performed.
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new
  def initialize
    @struct = []
  end

  # Creates a new item, the equivalent of a variable in the system.
  #
  # ==== Attributes
  #
  # * +name+ - the name of the new item, which is written as a symbol.
  # * +value+ - the contents of the new item, whether that be a string,
  #   variable or any other object.
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_item = Hitsuji.item(:foo, 'bar')            # a new item
  def self.item(name, value)
    Item.new(name, value)
  end

  # Creates a new linker, which is simply put a grouping of items and other
  # linkers.
  #
  # ==== Attributes
  #
  # * +name+ - the name of the new linker, which is written as a symbol.
  # * +value+ - the contents of the new linker, whether that be an item or
  #   another linker.
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_item = Hitsuji.item(:foo, 'bar')            # a new item
  #    my_item2 = Hitsuji.item(:qux, 'quux')          # a second item
  #    items = [:foo, :qux]
  #    my_linker = Hitsuji.linker(:baz, items)        # a new linker
  def self.linker(name, objs)
    Linker.new(name, objs)
  end

  # Creates a new operation, which is an equation performed on multiple items
  # contained within a linker. This linker can contain more linkers from which
  # more items will be progressively taken. An operation can then be used as
  # part of a linker, and the result can be used in another operation.
  #
  # ==== Attributes
  #
  # * +name+ - the name of the new linker, which is written as a symbol.
  # * +input+ - the contents of the new linker, whether that be an item or
  #   another linker.
  # * +block+ - a block as a string to perform the operation
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_item = Hitsuji.item(:foo, 1)                # a new item
  #    my_item2 = Hitsuji.item(:qux, 2)               # a second item
  #    items = [:foo, :qux]
  #    my_linker = Hitsuji.linker(:baz, items)        # a new linker
  #    my_op = Hitsuji.operation(:op, my_linker, %{
  #      |arg1, arg2| arg1 + arg2
  #    }) # => :foo + :qux => 1 + 2 => 3              # a new operation
  def self.operation(name, input, block)
    Operation.new(name, input, block)
  end

  # 'Binds' the inputted items to the system, allowing for the continous
  # updating of the values within a system. This continuous updating forms the
  # main principle of Hitsuji. Once bound, an object can only be edited using
  # the Hitsuji.find, Hitsuji.edit and Hitsuji.remove methods. It can never
  # share a name with any other bound object. Once bound, the name of an object
  # becomes uneditable, but the value still keeps its read-write capabilites.
  #
  # ==== Attributes
  #
  # * +obj+ - the items, linkers and operation you want to bind
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_item = Hitsuji.item(:foo, 1)                # a new item
  #    my_item2 = Hitsuji.item(:qux, 2)               # a second item
  #    items = [:foo, :qux]
  #    my_linker = Hitsuji.linker(:baz, items)        # a new linker
  #    my_system.bind(my_item, my_item2, my_linker)   # binds items + linker
  def bind(*obj)
    @struct.concat obj
    update @struct
  end

  # Exports the current state of the system to a file. This process *does not*
  # export unbound items, linkers or operations! Creating new items doesn't
  # automatically bind them to the system, so therefore the exported file
  # only contains objects bound with Hitsuji.bind.
  #
  # ==== Attributes
  #
  # * +directory+ - the path of the file to export the system (the extension
  #   of the file doesn't matter)
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_item = Hitsuji.item(:foo, 1)                # a new item
  #    my_system.bind(my_item)                        # binds item
  #    my_system.export('newfile.txt')                # exports to 'newfile.txt'
  def export(directory)
    Transfer.export(directory, @struct)
  end

  # Imports a file into a system, *overwriting anything already bound to the
  # system*.
  #
  # ==== Attributes
  #
  # * +directory+ - the path of the file you want to import from
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_system.import('oldfile.txt')                # imports 'oldfile.txt'
  def import(directory)
    @struct = Transfer.import(directory)
    update @struct
  end

  # Finds a bound object in the system by name, and returns the object if it
  # exists.
  #
  # ==== Attributes
  #
  # * +query+ - the name of the object to search for
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_system.import('oldfile.txt')                # imports 'oldfile.txt'
  #    my_item = my_system.find(:foo)                 # finds an item
  def find(query)
    get(query, @struct, nil, false)
  end

  # Finds a bound object in the system by name, edits the object if it exists,
  # and then returns the original object.
  #
  # ==== Attributes
  #
  # * +query+ - the name of the object to edit
  # * +value+ - the new value to assign to this object
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_system.import('oldfile.txt')                # imports 'oldfile.txt'
  #    my_item = my_system.edit(:foo, 'bar')          # changes an item
  def edit(query, value)
    get(query, @struct, value, false)
  end

  # Finds a bound object in the system by name, removes it if it exists, and
  # then returns the original object.
  #
  # ==== Attributes
  #
  # * +query+ - the name of the object to remove
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_system.import('oldfile.txt')                # imports 'oldfile.txt'
  #    my_item = my_system.remove(:foo)               # removes an item
  def remove(query)
    get(query, @struct, nil, true)
  end

  #--
  # BEGINNING OF PRIVATE FUNCTIONS
  #++

  # Updates state of system to monitor name usageand dependencies on operations.
  # This is run every time Hitsuji.bind or Hitsuji.import is run.
  #
  # ==== Attributes
  #
  # * +obj+ - the object to update (usually @struct)
  #
  # ==== Example
  #
  #    class MyHitsuji < Hitsuji                      # creates dependent class
  #      def linker_update                            # my new special function!
  #        @struct.each do |i|
  #          update(@struct) if i.class == Linker     # uses update function
  #        end
  #      end
  #    end
  def update(obj)
    names = []
    obj.each do |i|
      throw 'err' unless i.name.nil? || !names.include?(i.name)
      names << update(i.value) if i.class == Linker
    end
    names
  end

  # Gets value of item from @struct and returns it. It can perform additional
  # operations such as editing and removal.
  #
  # ==== Attributes
  #
  # * +query+ - the name of the object to perform the actions on
  # * +obj+ - the object to search in (usually @struct)
  # * +edit+ - the edit to make to the object (nil if not)
  # * +remove+ - whether to remove the object (false if not)
  #
  # ==== Example
  #
  #    class MyHitsuji < Hitsuji                      # creates dependent class
  #      def remove_from_linkers(query)               # my new special function!
  #        @struct.each do |i|
  #          if i.class == Linker
  #            get(query, @struct, nil, true)         # uses get function
  #          end
  #        end
  #      end
  #    end
  def get(query, obj, edit, remove)
    answer = nil
    obj.each do |i|
      if i.name == query
        answer = i
        if edit
          i.value = edit
        elsif remove
          i.name = nil
        end
      elsif i.class == Linker
        answer = view(query, i.value, edit, remove)
      end
    end
    answer
  end

  private :update, :get
end
