module Users
  # app/controllers/users/messages_controller.rb
  class MessagesController < UsersApplicationController
    before_action :set_breadcrumbs
    after_action :update_messages_to_read
    include Pagination

    def main
      @new_messages = current_user.notes.joins(:message).order('dated DESC', 'created_at DESC').where(visible_to_user: true, replaced_by: nil)
      @read_messages = []
      @new_messages.each do |message|
        if message.created >= 1.month.ago
          @read_messages.push(message)
        end
      end

      @notifications = current_user.messages
    end

    protected

    def resources
      current_user.notes.past.joins(:message).order('dated DESC', 'notes.created_at DESC')
                  .where(visible_to_user: true, replaced_by: nil)
    end

    def resources_per_page
      6
    end

    def search
      resources.joins(:team_member).where(team_member_search, wildcard_query)
    end

    private

    def update_messages_to_read
      return unless current_user.messages.where(read: false).present?

      current_user.messages.each do |message|
        message.update!(read: true)
      end
    end

    def set_breadcrumbs
      path = action_name == 'main' ? nil : main_messages_path
      add_breadcrumb('My Messages', path, 'fas fa-envelope')
      add_breadcrumb('Archive Messages') if action_name == 'index'
    end
  end
end
