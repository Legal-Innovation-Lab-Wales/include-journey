module TeamMembers
  # app/controllers/team_members/affirmations_archive_controller.rb
  class AffirmationsArchiveController < TeamMembersApplicationController
    include Pagination

    # GET /affirmations_archive
    def index
      render 'index'
    end

    protected

    def resources
      Affirmation.includes(:team_member).archived.order(scheduled_date: :desc)
    end

    def search
      self.resources
    end
  end
end
