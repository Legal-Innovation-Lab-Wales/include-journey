const dated_when_field = document.querySelector('#dated_when'),
    dated_time_field = document.querySelector('#dated_time'),
    note_dated_hidden_field = document.querySelector('#note_dated'),
    update_note_dated = () => note_dated_hidden_field.value = new Date(`${dated_when_field.value} ${dated_time_field.value}`)

dated_when_field.addEventListener('change', update_note_dated)
dated_time_field.addEventListener('change', update_note_dated)

update_note_dated()