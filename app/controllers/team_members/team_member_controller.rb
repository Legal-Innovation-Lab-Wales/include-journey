module TeamMembers
  # app/controllers/team_members/team_member_controller.rb
  class TeamMemberController < ApplicationController
    before_action :authenticate_team_member!
  end
end