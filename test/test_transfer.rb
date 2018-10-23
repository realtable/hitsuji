require 'minitest/autorun'
require 'tmpdir'
require 'hitsuji'

class HitsujiTest < Minitest::Test
  def test_all_transfer
    my_system = Hitsuji.new
    my_system2 = Hitsuji.new
    my_system3 = Hitsuji.new
    my_system4 = Hitsuji.new

    Dir.mktmpdir do |dir|
      # export test
      x = Hitsuji.item(:i, 2)
      my_system.bind(x)
      my_system.bind(Hitsuji.linker(:j, [x]))
      my_system.export(dir + 'hitsuji.hitsuji')

      my_system2.bind(x)
      my_system2.bind(Hitsuji.linker(:j, [x]))
      my_system2.export(dir + 'hitsuji2.hitsuji')

      sys = File.open(dir + 'hitsuji.hitsuji').readlines
      sys2 = File.open(dir + 'hitsuji2.hitsuji').readlines
      assert_equal sys, sys2

      # import test
      my_system3.import(dir + 'hitsuji.hitsuji')
      my_system4.import(dir + 'hitsuji2.hitsuji')

      my_system3.export(dir + 'hitsuji3.hitsuji')
      my_system4.export(dir + 'hitsuji4.hitsuji')

      sys3 = File.open(dir + 'hitsuji3.hitsuji').readlines
      sys4 = File.open(dir + 'hitsuji4.hitsuji').readlines
      assert_equal sys3, sys4
    end
  end
end
