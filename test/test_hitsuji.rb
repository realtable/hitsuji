require 'minitest/autorun'
require 'tmpdir'
require 'hitsuji'

class HitsujiTest < Minitest::Test
  def test_subsystem_interface
    my_system = Hitsuji.new
    assert_equal my_system.class, Hitsuji

    # item test
    my_item = Hitsuji.item(:a, 1)
    assert_equal my_item.class, Item
    assert_equal my_item.name, :a
    assert_equal my_item.value, 1

    # linker test
    my_item2 = Hitsuji.item(:b, 2)
    my_linker = Hitsuji.linker(:c, [my_item, my_item2])
    assert_equal my_linker.class, Linker
    assert_equal my_linker.name, :c
    assert_equal my_linker.value, [my_item, my_item2]

    # operation test
    my_op = Hitsuji.operation(:d, my_linker) { |arg1, arg2| arg1 + arg2 }
    assert_equal my_op.class, Operation
    assert_equal my_op.name, :d
    assert_equal my_op.input.class, Linker
    assert_equal my_op.input.name, :c
    assert_equal my_op.input.value, [my_item, my_item2]
    assert_equal my_op.call, 3
  end

  def test_transfer_interface
    my_system = Hitsuji.new
    my_system2 = Hitsuji.new
    my_system3 = Hitsuji.new

    Dir.mktmpdir do |dir|
      # export test
      x = Hitsuji.item(:i, 2)
      my_system.bind(x)
      my_system.bind(Hitsuji.linker(:j, [x]))
      my_system.export(dir + '/test_hitsuji.hitsuji')
      my_system.export(dir + '/test_hitsuji2.hitsuji')

      sys = File.open(dir + '/test_hitsuji.hitsuji').readlines
      sys2 = File.open(dir + '/test_hitsuji2.hitsuji').readlines
      assert_equal sys, sys2

      # import test
      my_system2.import(dir + '/test_hitsuji.hitsuji')
      my_system3.import(dir + '/test_hitsuji2.hitsuji')
      my_system2.export(dir + '/test_hitsuji3.hitsuji')
      my_system3.export(dir + '/test_hitsuji4.hitsuji')

      sys2 = File.open(dir + '/test_hitsuji3.hitsuji').readlines
      sys3 = File.open(dir + '/test_hitsuji4.hitsuji').readlines
      assert_equal sys2, sys3
    end
  end

  def test_system_interface
    my_system = Hitsuji.new
    my_item = Hitsuji.item(:foo, 'bar')
    my_item2 = Hitsuji.item(:baz, 'quux')
    my_system.bind(my_item, my_item2)

    # find test
    test_item = my_system.find(:foo)
    assert_equal my_item, test_item
    test_item2 = my_system.find(:baz)
    assert_equal my_item2, test_item2

    # edit test
    test_item3 = my_system.edit(:foo, 'bar2')
    assert_equal my_item, test_item3
    refute_equal Hitsuji.item(:foo, 'bar'), test_item3

    # remove test
    test_item5 = my_system.remove(:baz)
    assert_equal my_item2, test_item5
    test_item6 = my_system.find(:baz)
    assert_nil test_item6
  end
end
