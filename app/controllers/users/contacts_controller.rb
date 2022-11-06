module Users
  # app/controllers/users/contacts_controller.rb
  class ContactsController < UsersApplicationController
    before_action :set_breadcrumbs
    before_action :contact, only: %i[edit update destroy]
    include Pagination

    # GET /contacts/new
    def new
      add_breadcrumb('New Contact', nil, 'fas fa-plus-circle')
      @contact = Contact.new

      render 'new'
    end

    # POST /contacts
    def create
      if (@contact = current_user.contacts.create!(contact_params))
        redirect_to contacts_path, flash: { success: 'Contact created' }
      else
        redirect_to new_contact_path, flash: { error: 'Error creating contact' }
      end
    end

    # GET /contacts/:id/edit
    def edit
      add_breadcrumb('Edit Contact', nil, 'fas fa-edit')
      render 'edit'
    end

    # PUT /contacts/:id
    def update
      if (@contact = @contact.update!(contact_params))
        redirect_to contacts_path, flash: { success: 'Contact updated' }
      else
        redirect_to edit_contact_path, flash: { error: 'Error updating contact' }
      end
    end

    # DELETE /contacts/:id
    def destroy
      if @contact.destroy!
        redirect_to current_user.contacts.count.zero? ? authenticated_user_root_path : contacts_path, flash: { success: 'Contact removed' }
      else
        redirect_to edit_contact_path, flash: { error: 'Error removing contact' }
      end
    end

    protected

    def contact_search
      'lower(name) similar to lower(:query)'
    end

    def resources
      current_user.contacts.order(updated_at: :desc)
    end

    def resources_per_page
      9
    end

    def search
      current_user.contacts.where(contact_search, wildcard_query).order(updated_at: :desc)
    end

    private

    def contact
      @contact = current_user.contacts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: contacts_path, flash: { error: 'That contact does not exist' })
    end

    def contact_params
      params.require(:contact).permit(:name, :description, :number, :email)
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : contacts_path
      add_breadcrumb('My Contacts', path, 'fas fa-address-book')
    end
  end
end
