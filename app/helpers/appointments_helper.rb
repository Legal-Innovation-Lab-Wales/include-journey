# app/helpers/appointments_helper.rb
module AppointmentsHelper
  def datepicker_input(form, field)
    # TODO: why does this hash mix symbol and string keys?
    data = {
      provide: 'datepicker',
      'date-format' => 'yyyy-mm-dd',
      'date-autoclose' => 'true'
    }
    content_tag :td, data: data do
      form.text_field field, class: 'form-control', placeholder: 'YYYY-MM-DD'
    end
  end
end
