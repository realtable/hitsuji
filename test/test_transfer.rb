require 'minitest/autorun'
require 'tmpdir'
require 'hitsuji'

Temp = ENV['TMPDIR']

class HitsujiTest < Minitest::Test
  def test_export
    my_system = Hitsuji.new
    my_system2 = Hitsuji.new

    # export test
    x = Hitsuji.item(:i, 2)
    my_system.bind(x)
    my_system.bind(Hitsuji.linker(:j, [x]))
    my_system.export(Temp + 'hitsuji.tmp')

    my_system2.bind(x)
    my_system2.bind(Hitsuji.linker(:j, [x]))
    my_system2.export(Temp + 'hitsuji2.tmp')

    sys = File.open(Temp + 'hitsuji.tmp').readlines
    sys2 = File.open(Temp + 'hitsuji2.tmp').readlines
    assert_equal sys, sys2
  end

  def test_import
    my_system3 = Hitsuji.new
    my_system4 = Hitsuji.new

    # import test
    my_system3.import(Temp + 'hitsuji.tmp')
    my_system4.import(Temp + 'hitsuji2.tmp')

    my_system3.export(Temp + 'hitsuji3.tmp')
    my_system4.export(Temp + 'hitsuji4.tmp')

    sys3 = File.open(Temp + 'hitsuji3.tmp').readlines
    sys4 = File.open(Temp + 'hitsuji4.tmp').readlines
    assert_equal sys3, sys4
  end
end
