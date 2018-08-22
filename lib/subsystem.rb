# The Item class is the Hitsuji representation of a variable, and its properties
# include a name and a value. The value has read-write properties, but once the
# Item is bound, a seperate method must be used to read and change it. Examples
# of its use can be seen in the documentation for the Hitsuji.item method.
class Item
  def initialize(name, value) # :nodoc:
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
  def initialize(name, value) # :nodoc:
    @name = name
    @value = value
  end

  attr_accessor :name, :value
end

# The Operation class is the Hitsuji representation of an equation, and its
# properties include a name, a value and a block. The value is an Linker with
# read-write properties, and the values in this Linker are parsed into the block
# for execution. This block is not presented as block however, but as a string,
# only executed upon read of dependent values. Once the Operation is bound, a
# seperate method must be used to read them. Linkers are the main interface
# between Items and Operations. Examples of its use can be seen in the
# documentation for the Hitsuji.operation method.
class Operation
  def initialize(name, input, block) # :nodoc:
    @name = name
    @input = input
    @block = block
  end

  attr_reader :block
  attr_accessor :name, :input
end
