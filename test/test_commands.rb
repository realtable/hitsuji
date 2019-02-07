require 'minitest/autorun'
require 'tmpdir'
require 'hitsuji'

class CommandTest < Minitest::Test
  def test_help_version
    # help test
    assert_equal `bin/hitsuji -h`, `bin/hitsuji`
    assert_equal `bin/hitsuji --help`, `bin/hitsuji`
    assert_equal `bin/hitsuji convert -h`, `bin/hitsuji help convert`
    assert_equal `bin/hitsuji convert --help`, `bin/hitsuji help convert`
    assert_equal `bin/hitsuji metadata -h`, `bin/hitsuji help metadata`
    assert_equal `bin/hitsuji metadata --help`, `bin/hitsuji help metadata`

    # version test
    assert_equal `bin/hitsuji --version`, `bin/hitsuji -v`
  end

  def test_convert
    Dir.mktmpdir do |dir|
      # convert test
      my_system = Hitsuji.new
      my_system.export(dir + '/test_hitsuji.hitsuji')
      my_system.export(dir + '/test_hitsuji2.hitsuji')

      `bin/hitsuji convert -y #{dir}/test_hitsuji.hitsuji`
      `bin/hitsuji convert -h #{dir}/test_hitsuji.yml`

      sys = File.open(dir + '/test_hitsuji.hitsuji').readlines
      sys2 = File.open(dir + '/test_hitsuji2.hitsuji').readlines
      assert_equal sys, sys2
    end
  end

  def test_metadata
    Dir.mktmpdir do |dir|
      # metadata test
      my_system = Hitsuji.new
      my_system.export(dir + '/test_hitsuji.hitsuji')
      my_system.export(dir + '/test_hitsuji2.hitsuji')

      data1 = `bin/hitsuji metadata #{dir}/test_hitsuji.hitsuji`
      data2 = `bin/hitsuji metadata #{dir}/test_hitsuji2.hitsuji`
              .sub('test_hitsuji2.hitsuji', 'test_hitsuji.hitsuji')

      assert_equal data1, data2
    end
  end
end
