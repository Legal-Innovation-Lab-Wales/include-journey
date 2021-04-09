module Users
  # app/controllers/users/contacts_controller.rb
  class ContactsController < PaginationController
    before_action :contact, only: %i[edit update destroy]

    # GET /contacts/new
    def new
      @contact = Contact.new

      render 'new'
    end

    # GET /contacts/:id/edit
    def edit
      puts 'Edit the contact'
      render 'edit'
    end

    # PUT /contacts/:id
    def update
      puts 'Update the contact'
    end

    # POST /contacts
    def create
      if (@contact = current_user.contacts.create!(contact_params))
        redirect_to contacts_path, flash: { success: 'Contact created' }
      else
        redirect_to new_contact_path, flash: { error: 'That contact could not be created' }
      end
    end

    # DELETE /contacts/:id
    def destroy
      puts 'Destroy the contact'
    end

    protected

    # def multiple
    #   @multiple = 10
    # end

    def contact_search
      'lower(name) similar to lower(:query)'
    end

    def resources
      @resources =
        if @query.present?
          current_user.contacts.where(contact_search, wildcard_query).order(created_at: :desc)
        else
          current_user.contacts.order(created_at: :desc)
        end
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
  end
end
