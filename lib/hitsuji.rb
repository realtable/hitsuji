# -- hitsuji.rb --
# Main interface for hitsuji module

#require_relative 'transfer.rb'
require_relative 'subsystem.rb'

class Hitsuji
  
  # creates new system
  def initialize
    @struct = []
    @used_names = []
  end
  
  # creates new unbinded item
  def item(name, value)
    if @used_names.include? name
      throw 'err'
    else
      new_item = Item.new(name, value)
      @used_names << name
    end
    return new_item
  end
  
  # creates new unbinded linker
  def linker(name, objs)
    if @used_names.include? name
      throw 'err'
    else
      new_linker = Linker.new(name, objs)
      @used_names << name
    end
    return new_linker
  end
  
  # creates new unbined operation
  def operation(name, input)
    if @used_names.include? name
      throw 'err'
    else
      new_operation = Operation.new(name, input) do
        yield
      end
      @used_names << name
    end
    return new_operation
  end
  
  # binds object
  def bind(obj)
    @struct << obj
    #update
  end
  
end