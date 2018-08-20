# * Hitsuji

require 'transfer'
require 'subsystem'

class Hitsuji
  
  # Creates a new system where all operations can be performed.
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new
  def initialize
    @struct = []
  end
  
  # Creates a new item, the equivalent of a variable in the system. Once
  # declared, the value of an item can be changed but not the name. No item
  # is allowed to share the same name as any other.
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
  #    my_item = my_system.item(:foo, 'bar')          # a new item
  def item(name, value)
    new_item = Item.new(name, value)
    return new_item
  end
  
  # Creates a new linker, which is simply put a grouping of items and other
  # linkers. Like an item, the value is changeable but the name is not, and it
  # must not share its name with any other linker, or item for that matter.
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
  #    my_item = my_system.item(:foo, 'bar')          # a new item
  #    my_item2 = my_system.item(:qux, 'quux')        # a second item
  #    items = [:foo, :qux]
  #    my_linker = my_system.linker(:baz, items)      # a new linker
  def linker(name, objs)
    new_linker = Linker.new(name, objs)
    return new_linker
  end
  
  # Creates a new operation, which is an operation performed on multiple items
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
  #    my_item = my_system.item(:foo, 1)              # a new item
  #    my_item2 = my_system.item(:qux, 2)             # a second item
  #    items = [:foo, :qux]
  #    my_linker = my_system.linker(:baz, items)      # a new linker
  #    my_op = my_system.operation(:op, my_linker, %{ # a new operation
  #      |arg1, arg2| arg1 + arg2
  #    }) # => :foo + :qux => 1 + 2 => 3
  def operation(name, input, block)
    new_operation = Operation.new(name, input, block)
    return new_operation
  end
  
  # Binds the inputted items to the system, allowing for the continous updating
  # of the values within a system. This continuous updating is what gives
  # Hitsuji its computational power.
  #
  # ==== Attributes
  #
  # * +*obj+ - the items, linkers and operation you want to bind
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_item = my_system.item(:foo, 1)              # a new item
  #    my_item2 = my_system.item(:qux, 2)             # a second item
  #    items = [:foo, :qux]
  #    my_linker = my_system.linker(:baz, items)      # a new linker
  #    my_system.bind(my_item, my_item2, my_linker)   # binds items + linker
  def bind(*obj)
    @struct.concat obj
    #update
  end
  
  # Exports current state of system to a file. This process _does not export
  # unbound items, linkers or operations!_ Creating new items doesn't automatically bind them to the
  # system, even through they are a created with a method of a Hitsuji object.
  #
  # ==== Attributes
  #
  # * +directory+ - the path of the file to export the system (the extension
  #   of the file doesn't matter)
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_item = my_system.item(:foo, 1)              # a new item
  #    my_system.bind(my_item)                        # binds item
  #    my_system.export('newfile.txt')                # exports to 'newfile.txt'
  def export(directory)
    Transfer.export(directory, @struct)
  end
  
  # Imports file into a system, _overwriting anything already bound to the 
  # system_. 
  #
  # ==== Attributes
  #
  # * +directory+ - the path of the file you want to import from
  #
  # ==== Example
  #
  #    my_system = Hitsuji.new                        # a new system
  #    my_system.import('oldfile.txt')                # imports from 'newfile.txt'
  def import(directory)
    @struct = Transfer.import(directory)
    #update
  end

  private

  def self.update # :nodoc:
    # @struct.each do |val|
    #   case val.class
    #   when Item
    # 
    #   else
    # 
    #   end
    # end
  end
  
end