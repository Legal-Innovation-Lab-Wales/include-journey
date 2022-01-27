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
      Affirmation.includes(:team_member)
                 .archived
                 .order(sort)
    end

    def search
      Affirmation.includes(:team_member)
                 .where(affirmations_archive_search, query_terms)
                 .order(sort)
    end

    def sort
      
      @sort = 'scheduled_date'
      { "#{@sort}": @direction }
    end

    private

    def query_terms
      wildcard_query.merge({ today: Date.today })
    end

    def affirmations_archive_search
      'scheduled_date < :today and lower(text) similar to lower(:query)'
    end
  end
end
