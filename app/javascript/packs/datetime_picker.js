const date_field = document.querySelector('#appointment_when'),
      time_field = document.querySelector('#appointment_time'),
      hidden_field = document.querySelector('#appointment_start'),
      update = () => hidden_field.value = new Date(`${date_field.value} ${time_field.value}`)

date_field.addEventListener('change', update)
time_field.addEventListener('change', update)