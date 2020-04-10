require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
require 'rspec/autorun'

class StatTrackerTest < Minitest::Test
  attr_reader :stat_tracker
  def setup
    @stat_tracker = StatTracker.new
    stat_tracker.from_csv('./test/fixtures')
  end

  def test_it_exists
    stat_tracker = StatTracker.new
    assert_instance_of StatTracker, stat_tracker
  end

  def test_count_of_teams
    assert_equal 5, stat_tracker.count_of_teams
  end

  def test_total_games_per_team
    assert_equal 5, stat_tracker.total_games_per_team(3)
  end

  def test_best_offense
    assert_equal "FC Dallas", stat_tracker.best_offense
  end
end
