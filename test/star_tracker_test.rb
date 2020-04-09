require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def test_it_exists
    stat_tracker = StatTracker.new
    assert_instance_of StatTracker, stat_tracker
  end

  def test_count_of_teams
    stat_tracker = StatTracker.new
    assert_equal 32, stat_tracker.count_of_teams
  end
end
