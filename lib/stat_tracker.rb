require_relative 'CSV'
require_relative './lib/team'
require_relative './lib/game'

class StatTracker

  def initialize
    @teams = []
    @games = []
  end

# team_id,franchiseId,teamName,abbreviation,Stadium,link
#self.csv so its a class method should return instance of itself.
#instance of stat_tracker. Want one object returned want all this code in
#entry point into the program. One place that knows everything. Collection
#of teams, of games, etc. One instance of stat_tracker.

  def load_from_csv(root_path = "./data")
    CSV.foreach("#{root_path}/teams.csv", headers: true, header_converters: :symbol) do |row|
      data = {team_id: row[:team_id],
              franchiseid: row[:franchiseid],
              teamname: row[:teamname],
              abbreviation: row[:abbreviation],
              stadium: row[:stadium],
              link: row[:link]
            }
      @teams << Team.new(data)
    end

    CSV.foreach("#{root_path}/games.csv", headers: true, header_converters: :symbol) do |row|
      data = {game_id: row[:game_id],
              season: row[:season],
              type: row[:type],
              date_time: row[:date_time],
              away_team_id: row[:away_team_id],
              home_team_id: row[:home_team_id],
              away_goals: row[:away_goals],
              home_goals: row[:home_goals],
              venue: row[:venue],
              venue_link: row[:venue_link]
            }
      @games << Game.new(data)
    end
  end

  def count_of_teams
    @teams.size
  end

  def best_offense
    # team with highest average goals per game
    # team_average = total_goals / all_games

    average_goals_per_team = @teams.map do |team|
      # get the total number of goals
      total_goals = total_goals_per_team(team.id)
      # total_goals = team.total_goals_in_season
      total_games = total_games_per_team(team.id)
      # get the total number of games
      if total_games != 0
        {
          team.name => total_goals / total_games
        }
      else
        {
          team.name => 0
        }
      end
    end

    average_goals_per_team.max do |statistic|
      statistic.values.first
    end.keys.first
  end

  def total_goals_per_team(team_id)
    @games.sum do |game|
      is_home_team = game.home_team_id == team_id
      is_away_team = game.away_team_id == team_id
      if is_home_team
        game.home_goals
      elsif is_away_team
        game.away_goals
      else
        0
      end
    end
  end

  def total_games_per_team(team_id)
    @games.sum do |game|
      is_home_team = game.home_team_id == team_id
      is_away_team = game.away_team_id == team_id
      if is_home_team || is_away_team
        1
      else
        0
      end
    end
  end
end
