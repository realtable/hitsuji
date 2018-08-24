require 'minitest/autorun'
require 'tmpdir'
require 'hitsuji'

class HitsujiTest < Minitest::Test
  def test_export
    temp = Dir.tmpdir
    my_system = Hitsuji.new
    my_system2 = Hitsuji.new

    # export test
    x = Hitsuji.item(:i, 2)
    my_system.bind(x)
    my_system.bind(Hitsuji.linker(:j, [x]))
    my_system.export(temp + '/hitsuji.tmp')

    my_system2.bind(x)
    my_system2.bind(Hitsuji.linker(:j, [x]))
    my_system2.export(temp + '/hitsuji2.tmp')

    sys = File.open(temp + '/hitsuji.tmp').readlines
    sys2 = File.open(temp + '/hitsuji2.tmp').readlines
    assert_equal sys, sys2
  end

  def test_import
    temp = Dir.tmpdir
    my_system3 = Hitsuji.new
    my_system4 = Hitsuji.new

    # import test
    my_system3.import(temp + '/hitsuji.tmp')
    my_system4.import(temp + '/hitsuji2.tmp')

    my_system3.export(temp + '/hitsuji3.tmp')
    my_system4.export(temp + '/hitsuji4.tmp')

    sys3 = File.open(temp + '/hitsuji3.tmp').readlines
    sys4 = File.open(temp + '/hitsuji4.tmp').readlines
    assert_equal sys3, sys4
  end
end
