# frozen_string_literal: true

module TeamMembers
  # app/controllers/team_members/affirmations_archive_controller.rb
  class AffirmationsArchiveController < TeamMembersApplicationController
    before_action :set_breadcrumbs
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
      {@sort => @direction}
    end

    private

    def query_terms
      wildcard_query.merge(today: Date.today)
    end

    def affirmations_archive_search
      'scheduled_date < :today and lower(text) similar to lower(:query)'
    end

    def set_breadcrumbs
      add_breadcrumb('Daily Affirmations', affirmations_path, 'fas fa-smile')
      add_breadcrumb('Archive', nil, 'fas fa-archive')
    end
  end
end
