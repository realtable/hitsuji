require 'minitest/autorun'
require 'hitsuji'

class HitsujiTest < Minitest::Test
  
  def test_main
    # system test
    my_system = Hitsuji.new
    assert_equal my_system.class, Hitsuji
    
    # item test
    my_item = my_system.item(:a, '1')
    assert_equal my_item.class, Item
    assert_equal my_item.name, :a
    assert_equal my_item.value, '1'
    
    # linker test
    my_item2 = my_system.item(:b, '2')
    my_linker = my_system.linker(:c, [my_item, my_item2])
    assert_equal my_linker.class, Linker
    assert_equal my_linker.name, :c
    assert_equal my_linker.value, [my_item, my_item2]
    
    # operation test
    my_op = my_system.operation(:d, my_linker) do |arg1, arg2|
      arg1 + arg2
    end
    assert_equal my_op.class, Operation
    assert_equal my_op.name, :d
    assert_equal my_op.input.class, Linker
    assert_equal my_op.input.name, :c
    assert_equal my_op.input.value, [my_item, my_item2]
  end
  
end