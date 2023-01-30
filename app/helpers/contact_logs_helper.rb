# app/helpers/contact_logs_helper.rb
module ContactLogsHelper
  def datepicker_input form, field
    content_tag :td, :data => {:provide => 'datepicker', 'date-format' => 'yyyy-mm-dd', 'date-autoclose' => 'true'} do
      form.text_field field, class: 'form-control', placeholder: 'YYYY-MM-DD'
    end
  end

  def truncate(string, max)
    string.length > max ? "#{string[0..max]}..." : string
  end
end
