require 'method_source'

# The Item class is the Hitsuji representation of a variable, and its properties
# include a name and a value. The value has read-write properties, but once the
# Item is bound, a seperate method must be used to read and change it. Examples
# of its use can be seen in the documentation for the Hitsuji.item method.
class Item
  def initialize(name, value)
    @name = name
    @value = value
  end

  attr_accessor :name, :value
end

# The Linker class is the Hitsuji representation of an array, and its properties
# include a name and a value. The value is an array with read-write properties,
# but once the Linker is bound, a seperate method must be used to read and
# change it. Linkers are the main interface between Items and Operations.
# Examples of its use can be seen in the documentation for the Hitsuji.linker
# method.
class Linker
  def initialize(name, value)
    @name = name
    @value = value
  end

  attr_accessor :name, :value
end

# The Operation class is the Hitsuji representation of an equation, and its
# properties include a name, a value and a block. The value is an Linker with
# read-write properties, and the values in this Linker are parsed into the block
# for execution. This block is only executed upon read of dependent values. Once
# the Operation is bound, a seperate method must be used to read them. Linkers
# are the main interface between Items and Operations. Examples of its use can
# be seen in the documentation for the Hitsuji.operation method.
class Operation
  def initialize(name, input, block)
    @name = name
    @input = input
    src = MethodSource.source_helper(block.source_location)
    @block = 'proc ' + src.match(/(do|\{)+?(.|\s)*(end|\})+?/).to_s
  end

  def call
    eval(@block).call(recurse(@input.value))
  end

  def recurse(obj)
    res = []
    obj.each do |n|
      res << n.value if n.class == Item
      res << n.call_proc if n.class == Operation
      res << recurse(n.value) if n.class == Linker
    end
    res
  end

  private :recurse
  attr_reader :block
  attr_accessor :name, :input
end
