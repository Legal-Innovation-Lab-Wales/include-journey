module Users
  # app/controllers/users/contacts_controller.rb
  class ContactsController < PaginationController
    before_action :contact, except: :index
    
    protected

    def resources
      @resources = Contact.order(created_at: :desc)
    end
  end
end
