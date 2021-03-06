require_relative 'transfer.rb'
require_relative 'subsystem.rb'
require_relative 'control.rb'

# The Hitsuji class is the interface to this module, and it contains
# all the functions you need. Examples using this class can be found in the
# descriptions of the class and instance methods below.
class Hitsuji
  # Creates a new empty system.
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new
  def initialize
    @struct = []
    @metadata = {
      date_created: `date`,
      date_edited: `date`
    }
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
  # * +block+ - a block that performs the operation
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_item = Hitsuji.item(:foo, 1)                # a new item
  #    my_item2 = Hitsuji.item(:qux, 2)               # a second item
  #    items = [:foo, :qux]
  #    my_linker = Hitsuji.linker(:baz, items)        # a new linker
  #    my_op = Hitsuji.operation(:op, my_linker) {
  #      |arg1, arg2| arg1 + arg2
  #    } # => :foo + :qux => 1 + 2 => 3              # a new operation
  def self.operation(name, input, &block)
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
  # * +obj+ - the items, linkers and operations you want to bind
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
    Control.update @struct
    @metadata[:date_edited] = `date`
  end

  # Exports the current state of the system to a file. This process *does not*
  # export unbound items, linkers or operations! Creating new items doesn't
  # automatically bind them to the system, so therefore the exported file
  # only contains objects bound with Hitsuji.bind. The Hitsuji file must end
  # with ".hitsuji".
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
  #    my_system.export('newfile.hitsuji')            # exports to 'newfile.txt'
  def export(directory)
    Transfer.export(directory, @struct, @metadata)
  end

  # Imports a file into a system, *overwriting anything already bound to the
  # system*. The Hitsuji file must end with ".hitsuji".
  #
  # ==== Attributes
  #
  # * +directory+ - the path of the file you want to import from
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_system.import('oldfile.hitsuji')            # imports 'oldfile.txt'
  def import(directory)
    @struct, @metadata = Transfer.import(directory)
    Control.update @struct
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
  #    my_system.import('oldfile.hitsuji')            # imports 'oldfile.txt'
  #    my_item = my_system.find(:foo)                 # finds an item
  def find(query)
    Control.get(query, @struct, nil, false)
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
  #    my_system.import('oldfile.hitsuji')            # imports 'oldfile.txt'
  #    my_item = my_system.edit(:foo, 'bar')          # changes an item
  def edit(query, value)
    Control.get(query, @struct, value, false)
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
  #    my_system.import('oldfile.hitsuji')            # imports 'oldfile.txt'
  #    my_item = my_system.remove(:foo)               # removes an item
  def remove(query)
    Control.get(query, @struct, nil, true)
  end
end
