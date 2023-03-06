module Users
  # app/controllers/users/team_members_notes_controller.rb
  class TeamMembersNotesController < UsersApplicationController
    def index
      @team_members_notes = Note.where(visible_to_user: true, user: current_user)
    end
  end
end
