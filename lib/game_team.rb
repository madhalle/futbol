class GameTeam
  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles,
              :pim,
              :powerPlayOpportunities,
              :powerPlayGoals,
              :faceOffWinPercentage,
              :giveaways,
              :takeaways

  def initialize(game_team_info)
    @game_id = game_team_info[:game_id]
    @team_id = game_team_info[:team_id]
    @hoa = game_team_info[:hoa]
    @result = game_team_info[:result]
    @settled_in = game_team_info[:settled_in]
    @head_coach = game_team_info[:head_coach]
    @goals = game_team_info[:goals]
    @shots = game_team_info[:shots]
    @tackles = game_team_info[:tackles]
    @pim = game_team_info[:pim]
    @powerPlayOpportunities = game_team_info[:powerPlayOpportunities]
    @powerPlayGoals = game_team_info[:powerPlayGoals]
    @faceOffWinPercentage = game_team_info[:faceOffWinPercentage]
    @giveaways = game_team_info[:giveaways]
    @takeaways = game_team_info[:takeaways]
  end

end
