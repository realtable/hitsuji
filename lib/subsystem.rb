# item object
class Item
  
  def initialize(name, value)
    @name = name
    @value = value
  end
  
  attr_reader :name
  attr_accessor :value
  
end

# linker object
class Linker
  
  def initialize(name, value)
    for i in value
      if i.class != Linker and i.class != Item
        throw 'err'
      end
    end
    
    @name = name
    @value = value
  end
  
  attr_reader :name
  attr_accessor :value
  
end

# operation object
class Operation
  
  def initialize(name, input, &func)     
    @name = name 
    @input = input
    @block = func
  end
  
  attr_reader :name, :input
  
end