require 'minitest/autorun'
require 'hitsuji'

class HitsujiTest < Minitest::Test
  def test_export
    my_system = Hitsuji.new
    my_system2 = Hitsuji.new

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
  end

  def test_import
    my_system3 = Hitsuji.new
    my_system4 = Hitsuji.new

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
