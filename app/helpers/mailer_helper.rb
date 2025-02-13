# frozen_string_literal: true

# app/helpers/mailer_helper.rb
module MailerHelper
  def email_image_tag(image, **options)
    attachments.inline[image] = Rails.root.join("app/assets/images/mailer/#{image}").read
    image_tag(attachments[image].url, **options)
  end
end
