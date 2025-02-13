# frozen_string_literal: true

module TeamMembers
  class ErrorsController < ApplicationController
    def internal_server_error
      add_breadcrumb('Error Page', nil, 'fas fa-thumbs-down')
      render status: :internal_server_error
    end
  end
end
