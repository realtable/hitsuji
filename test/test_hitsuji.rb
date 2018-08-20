require 'minitest/autorun'
require 'hitsuji'

class HitsujiTest < Minitest::Test
  def test_subsystem_interface
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
    my_op = my_system.operation(:d, my_linker, %( |arg1, arg2| arg1 + arg2 ))
    assert_equal my_op.class, Operation
    assert_equal my_op.name, :d
    assert_equal my_op.input.class, Linker
    assert_equal my_op.input.name, :c
    assert_equal my_op.input.value, [my_item, my_item2]
  end

  def test_transfer_interface
    my_system = Hitsuji.new
    my_system2 = Hitsuji.new
    my_system3 = Hitsuji.new
    my_system4 = Hitsuji.new

    # export test
    x = my_system.item(:i, 2)
    my_system.bind(x)
    my_system.bind(my_system.linker(:j, [x]))
    my_system.export('/tmp/test_hitsuji.tmp')

    my_system2.bind(x)
    my_system2.bind(my_system.linker(:j, [x]))
    my_system2.export('/tmp/test_hitsuji2.tmp')

    sys = File.open('/tmp/test_hitsuji.tmp').readlines
    sys2 = File.open('/tmp/test_hitsuji2.tmp').readlines
    assert_equal sys, sys2

    # import test
    my_system3.import('/tmp/test_hitsuji.tmp')
    my_system4.import('/tmp/test_hitsuji2.tmp')
    my_system3.export('/tmp/test_hitsuji3.tmp')
    my_system4.export('/tmp/test_hitsuji4.tmp')

    sys3 = File.open('/tmp/test_hitsuji3.tmp').readlines
    sys4 = File.open('/tmp/test_hitsuji4.tmp').readlines
    assert_equal sys3, sys4
  end
end
