require 'transfer'
require 'subsystem'

# The Hitsuji class is the interface to the Hitsuji module, and it contains
# all the functions you need to use Hitsuji to its fullest extent. Examples of
# this class can be found below, as well as in the README on GitHub.
#
# ==== Example 1
#
#     # getting the Hitsuji library from RubyGems
#     require 'rubygems'
#     require 'hitsuji'
#
#     # creating a system and importing some values we had before into it
#     my_system = Hitsuji.new
#     my_system.import('/a/valid/path')
#
#     # making some new items for our system
#     my_item = my_system.item(:foo, 'Hey look, a new item!')
#     my_item2 = my_system.item(:bar, 'And another.')
#
#     # making a linker with those items in it
#     my_linker = my_system.linker(:baz, [my_item, my_item2])
#     my_system.bind(my_item2, my_linker)
#
#     # exporting it for future use
#     my_system.export('/another/valid/path')
#
# ==== Example 2
#
#     # getting the Hitsuji library from RubyGems
#     require 'rubygems'
#     require 'hitsuji'
#
#     # creating a new blank system
#     my_system = Hitsuji.new
#
#     # adding two items and a linker with them both
#     my_item = my_system.item(:foo, 42)
#     my_item2 = my_system.item(:bar, 19)
#     my_linker = my_system.linker(:baz, [my_item, my_item2])
#
#     # putting the linker into an operation
#     my_system.bind(my_linker)
#     my_op = my_system.operation(:quux, my_linker, %{
#       |arg1, arg2| arg1 * arg2 - arg2 % arg1
#     }) # => (42 * 19) - (19 % 42) => 779
#
#     # putting the operation into a new linker and then that into an operation
#     my_linker2 = my_system.linker(:name, [my_linker, my_op])
#     my_op2 = my_system.operation(:name2, my_linker2, %{
#       |arg1, arg2, arg3| arg3 - arg1 / arg2 + 10
#     }) # => 779 - (42 / 19) + 10 => 786.79 (to nearest 2 d.p.)
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
    new_item
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
    new_linker
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
    new_operation
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
    # update @struct
  end

  # Exports current state of system to a file. This process _does not export
  # unbound items, linkers or operations!_ Creating new items doesn't
  # automatically bind them to the system, even through they are a created with
  # a method of a Hitsuji object.
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
  #    my_system.import('oldfile.txt')                # imports 'oldfile.txt'
  def import(directory)
    @struct = Transfer.import(directory)
    # update @struct
  end

  def self.update(obj) # :nodoc:
    # names = []
    # obj.each do |i|
    #   throw 'err' if names.include?(i.name)
    #   next unless i.class == Linker
    #   update(linker.value).each do |j|
    #     case j.class
    #     when Item, Linker, Operator
    #       names << j.name
    #     else
    #       throw 'err'
    #     end
    #   end
    # end
    #
    # names
  end
end
