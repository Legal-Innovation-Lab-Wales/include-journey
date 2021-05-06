const start_date_field = document.querySelector('#appointment_start_when'),
      start_time_field = document.querySelector('#appointment_start_time'),
      start_hidden_field = document.querySelector('#appointment_start'),
      update_start = () => start_hidden_field.value = new Date(`${start_date_field.value} ${start_time_field.value}`),
      end_date_field = document.querySelector('#appointment_end_when'),
      end_time_field = document.querySelector('#appointment_end_time'),
      end_hidden_field = document.querySelector('#appointment_end'),
      update_end = () => end_hidden_field.value = new Date(`${end_date_field.value} ${end_time_field.value}`)

start_date_field.addEventListener('change', update_start)
start_time_field.addEventListener('change', update_start)
end_date_field.addEventListener('change', update_end)
end_time_field.addEventListener('change', update_end)

update_start()
update_end()