module Users
  # app/controllers/users/messages_controller.rb
  class MessagesController < UsersApplicationController
    before_action :set_breadcrumbs
    after_action :update_messages_to_read
    include Pagination

    def main
      @messages = current_user.notes.joins(:message).order('dated DESC', 'created_at DESC').where(visible_to_user: true,
                                                                                                  replaced_by: nil)
      @notifications = current_user.messages
    end

    protected

    def resources
      if older_dated_notes?
        current_user.notes.past_dated.joins(:message).order('dated DESC', 'notes.created_at DESC')
                    .where(visible_to_user: true, replaced_by: nil)
      elsif older_created_notes?
        current_user.notes.past_created.joins(:message).order('dated DESC', 'notes.created_at DESC')
                    .where(visible_to_user: true, replaced_by: nil)
      end
    end

    def resources_per_page
      6
    end

    # def search
    #   current_user.appointments.where(appointment_search, wildcard_query).order(start: :desc)
    # end

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

    def older_dated_notes?
      current_user.notes.past_dated.joins(:message)
                  .where(visible_to_user: true, replaced_by: nil).present?
    end

    def older_created_notes?
      current_user.notes.past_created.joins(:message)
                  .where(visible_to_user: true, replaced_by: nil).present?
    end
  end
end
