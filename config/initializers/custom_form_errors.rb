# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  fragment = Nokogiri::HTML.fragment(html_tag)
  field = fragment.at('input,select,textarea')
  error_messages = instance.object.errors.messages

  html = nil
  if field
    field['class'] = "#{field['class']} invalid"

    value = field.attributes['name']
      .value
      .match(/\[(.*?)\]/)[0]
      .delete('[]')
      .gsub('_', ' ')

    error_message = error_messages[value.to_sym][0]
    error_message = 'is invalid' if error_message.blank?

    html = <<~HTML
      #{fragment}#{' '}
      <span class="error-message">
      #{value.capitalize} #{error_message}
      </span>
    HTML
    html
  else
    html = html_tag
  end

  html.html_safe
end
