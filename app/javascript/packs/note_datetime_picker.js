const optional_date_field = document.querySelector('#optional_date_when'),
    optional_time_field = document.querySelector('#optional_date_time'),
    note_optional_date_hidden_field = document.querySelector('#note_optional_date'),
    update_note_optional_date = () => note_optional_date_hidden_field.value = new Date(`${optional_date_field.value} ${optional_time_field.value}`)

optional_date_field.addEventListener('change', update_note_optional_date)
optional_time_field.addEventListener('change', update_note_optional_date)

update_note_optional_date()