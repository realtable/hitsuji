class Item
  
  def initialize(name, value) # :nodoc:
    @name = name
    @value = value
  end
  
  attr_reader :name
  attr_accessor :value
  
end

class Linker

  def initialize(name, value) # :nodoc:
    #value.each do |i|
    #  if i.class != Linker and i.class != Item
    #    throw 'err'
    #  end
    #end
    
    @name = name
    @value = value
  end
  
  attr_reader :name
  attr_accessor :value
  
end

class Operation
  
  def initialize(name, input, block) # :nodoc:  
    @name = name 
    @input = input
    @block = block
  end
  
  attr_reader :name, :input, :block
  
end