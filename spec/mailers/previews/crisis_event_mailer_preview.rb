# Preview all emails at http://localhost:3000/rails/mailers/crisis_event_mailer
class AdminMailerPreview < ActionMailer::Preview
  # Accessible from /new_crisis_email
  def new_crisis_email
    @admin = TeamMember.admins.first
    @user = User.first
    @crisis_event = @user.crisis_events.first
    @crisis_type = @crisis_event.crisis_type.category
    AdminMailer.new_crisis_email(@user, @admin, @crisis_event, @crisis_type)
  end

  def updated_crisis_email
    @admin = TeamMember.admins.first
    @user = User.first
    @crisis_event = @user.crisis_events.last
    @crisis_type = @crisis_event.crisis_type.category
    @crisis_notes = @crisis_event.crisis_notes.includes(:team_member)
    AdminMailer.updated_crisis_email(@user, @admin, @crisis_event, @crisis_type, @crisis_notes)
  end
end
