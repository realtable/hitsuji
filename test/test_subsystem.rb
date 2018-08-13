require 'minitest/autorun'
require_relative '../lib/subsystem.rb'

class SubsystemTest < Minitest::Test
  
  # testing item class
  def test_item
    # read test
    my_item = Item.new(:a, 'b')
    assert_equal my_item.class, Item
    assert_equal my_item.name, :a
    assert_equal my_item.value, 'b'
    
    # write test
    my_item.value = 'c'
    assert_equal my_item.value, 'c'
  end
  
  # testing linker class
  def test_linker
    # read test
    my_linker = Linker.new(:b, [])
    assert_equal my_linker.class, Linker
    assert_equal my_linker.name, :b
    assert_equal my_linker.value, []
    
    # write test
    my_item2 = Item.new(:z, 'z')
    my_linker.value = [my_item2]
    assert_equal my_linker.value, [my_item2]
  end
  
  # testing operator class
  def test_operator
    # init
    my_item3 = Item.new(:y, 'y')
    my_item4 = Item.new(:x, 'x')
    my_linker2 = Linker.new(:b2, [my_item3, my_item4])
    my_op = Operation.new(:c, my_linker2) do |arg1, arg2|
      arg1 + arg2
    end
    
    # read test
    assert_equal my_op.class, Operation
    assert_equal my_op.name, :c
    assert_equal my_op.input.class, Linker
    assert_equal my_op.input.name, :b2
    assert_equal my_op.input.value, [my_item3, my_item4]
  end
  
end