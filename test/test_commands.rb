require 'minitest/autorun'

COMMAND_PREFIX = 'ruby -Ilib ' + __dir__ + '/../bin/hitsuji'

class HitsujiTest < Minitest::Test
  def test_main_command
    assert_equal `#{COMMAND_PREFIX} -h`, `#{COMMAND_PREFIX}`
    assert_equal `#{COMMAND_PREFIX} -h`, `#{COMMAND_PREFIX} --help`
    assert_equal `#{COMMAND_PREFIX} -v`, `#{COMMAND_PREFIX} --version`
  end

  def test_help_command
    assert_equal `#{COMMAND_PREFIX} help evaluate`,
                 `#{COMMAND_PREFIX} evaluate -h`
    assert_equal `#{COMMAND_PREFIX} help evaluate`,
                 `#{COMMAND_PREFIX} evaluate`
  end
end
