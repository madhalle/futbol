require 'CSV'
require_relative 'team'
require_relative 'team_collection'
require_relative 'game'
require_relative 'games_methods'
require_relative 'game_team_collection'

    # game_teams.game_teams is equal to this ".all" method.
class StatTracker
  attr_reader :games, :teams, :game_teams

  def self.from_csv(file_paths)
    game_path = file_paths[:games]
    team_path = file_paths[:teams]
    game_teams_path = file_paths[:game_teams]

    StatTracker.new(game_path, team_path, game_teams_path)
  end

  def initialize(game_path, team_path, game_teams_path)
    @games = Games.new(game_path)
    @teams = Teams.new(team_path)
    @game_teams = GameTeams.new(game_teams_path)
  end

#dont want a path as an instance varaible. ONly use path once
#every time we call teams its initializing a new team every time
  # def games
  #   Games.new(@game_path)
  # end
  #
  # def teams
  #   Teams.new(@team_path)
  # end
  #
  # def game_teams
  #   GameTeams.new(@game_teams_path)
  # end



  def count_of_teams
    @teams.all.size
  end

  # Name of the team with the highest average
  # score per game across all seasons when they are away.
  # {team_name: num_goals, team_name2: num_goals...}

  def highest_scoring_visitor
    away_team_goals = @games.all.reduce(Hash.new(0)) do |teams, game|
      teams[game.away_team_id] += game.away_goals
      teams
    end
    away_team_id = away_team_goals.max_by{|team_id, away_goals| away_goals}.first
    # get key value pair where the value is the highest
    # find team that has the key
    @teams.find_by_team_id(away_team_id).team_name
  end

  def worst_offense
    average_goals_per_team = @teams.all.map do |team|
      total_goals = total_goals_per_team(team.team_id)
      total_games = total_games_per_team(team.team_id)
      if total_games != 0
        {
          team.team_name => total_goals / total_games
        }
      else
        {
          team.team_name => 0
        }
      end
    end
    average_goals_per_team.min do |statistic|
      statistic.values.first
    end.keys.first

  end

  def best_offense
    average_goals_per_team = @teams.all.map do |team|
      total_goals = total_goals_per_team(team.team_id)
      total_games = total_games_per_team(team.team_id)
      if total_games != 0
        {
          team.team_name => total_goals / total_games
        }
      else
        {
          team.team_name => 0
        }
      end
    end
    average_goals_per_team.max do |statistic|
      statistic.values.first
    end.keys.first
  end

  def total_goals_per_team(team_id)
    @games.all.sum do |game|
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
    @games.all.sum do |game|
      is_home_team = game.home_team_id == team_id
      is_away_team = game.away_team_id == team_id
      if is_home_team || is_away_team
        1
      else
        0
      end
    end
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

  def winningest_coach(season_id)
    head_coach_wins = {}
    @game_teams.all.each do |game_team|
      if season_id.to_i.divmod(10000)[1] - 1 == game_team.game_id.divmod(1000000)[0]
        if game_team.result == "WIN"
          head_coach = game_team.head_coach
          if head_coach_wins.key?(head_coach)
            head_coach_wins[head_coach] += 1
            #symbol return value was nil
            # nil because the key didn't exist yet.
            # which means that when we tried to add +=1, it didn't work bc of nil.
            #we wanted to make it dynamic for every head coach name.
          else
            head_coach_wins[head_coach] = 1
          end
        end
      end
    end
    # require "pry";binding.pry
    head_coach_wins.max_by{|k,v| v}[0]
  end

  def worst_coach(season_id)
    head_coach_losses = {}
    @game_teams.all.each do |game_team|
      if season_id.to_i.divmod(10000)[1] - 1 == game_team.game_id.divmod(1000000)[0]
        if game_team.result == "LOSS"
          head_coach = game_team.head_coach
          if head_coach_losses.key?(head_coach)
            head_coach_losses[head_coach] += 1
          else
            head_coach_losses[head_coach] = 1
          end
        end
      end
    end
    head_coach_losses.max_by{|k,v| v}[0]
  end
  
end

#   def initialize
#     @teams = []
#     @games = []
#   end
#
# # team_id,franchiseId,teamName,abbreviation,Stadium,link
#
#   def load_from_csv(root_path = "./data")
#     CSV.foreach("#{root_path}/teams.csv", headers: true, header_converters: :symbol) do |row|
#       data = {team_id: row[:team_id],
#               franchiseid: row[:franchiseid],
#               teamname: row[:teamname],
#               abbreviation: row[:abbreviation],
#               stadium: row[:stadium],
#               link: row[:link]
#             }
#       @teams << Team.new(data)
#     end
#
#     CSV.foreach("#{root_path}/games.csv", headers: true, header_converters: :symbol) do |row|
#       data = {game_id: row[:game_id],
#               season: row[:season],
#               type: row[:type],
#               date_time: row[:date_time],
#               away_team_id: row[:away_team_id],
#               home_team_id: row[:home_team_id],
#               away_goals: row[:away_goals],
#               home_goals: row[:home_goals],
#               venue: row[:venue],
#               venue_link: row[:venue_link]
#             }
#       @games << Game.new(data)
#     end
#   end
#
#   def count_of_teams
#     @teams.size
#   end
#
#
#   def total_games_per_team(team_id)
#     @games.sum do |game|
#       is_home_team = game.home_team_id == team_id
#       is_away_team = game.away_team_id == team_id
#       if is_home_team || is_away_team
#         1
#       else
#         0
#       end
#     end
#   end
