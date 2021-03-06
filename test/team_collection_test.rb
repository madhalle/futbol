require_relative 'test_helper'
require 'csv'
require './lib/team_collection'
require './lib/team'

class TeamCollectionTest < Minitest::Test
  def setup
    @team_collection = TeamCollection.new("./data/teams.csv")
    @team = @team_collection.teams.first
  end

  def test_it_exists
    assert_instance_of TeamCollection, @team_collection
  end

  def test_it_has_team_info
    expected = {:team_id => 1,
                :franchise_id => 23,
                :team_name => "Atlanta United",
                :abbreviation => "ATL",
                :link => "/api/v1/teams/1"}
    assert_equal expected, @team_collection.team_info(1)
    # require "pry";binding.pry
  end

  def test_it_can_create_teams_from_csv
    assert_instance_of Team, @team
    assert_equal 1, @team.team_id
    assert_equal "Atlanta United", @team.team_name
  end

  def test_it_has_all
    assert_equal @team_collection.teams, @team_collection.all
  end

  def test_find_by_team_id
    assert_equal @team, @team_collection.find_by_team_id(@team.team_id)
  end
end
