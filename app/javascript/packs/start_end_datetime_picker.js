const groupedDateValidation = (name) => {
  const start_date_field = document.querySelector(`#${name}_start_when`),
      start_time_field = document.querySelector(`#${name}_start_time`),
      start_hidden_field = document.querySelector(`#${name}_start`),
      update_start = () => {
          start_hidden_field.value = new Date(`${start_date_field.value} ${start_time_field.value}`)
          setMinDate(start_date_field.value)
          setEndTime()
      },
      end_date_field = document.querySelector(`#${name}_end_when`),
      end_time_field = document.querySelector(`#${name}_end_time`),
      end_hidden_field = document.querySelector(`#${name}_end`),
      update_end = () =>{
         end_hidden_field.value = new Date(`${end_date_field.value} ${end_time_field.value}`)
         setEndTime()
      },
      setMinDate = (value) =>{
         end_date_field.setAttribute('min', value)
      },
      setEndTime = ()=> {
        if (start_date_field.value === end_date_field.value) {
          const startDateTime = new Date(`${start_date_field.value} ${start_time_field.value}`);
          const endDateTime = new Date(`${end_date_field.value} ${end_time_field.value}`);
          if(startDateTime.getTime() > endDateTime.getTime()){
            end_time_field.value = start_time_field.value
          }
          end_time_field.setAttribute('min', start_time_field.value)
        }
      }

  start_date_field.addEventListener('change', update_start)
  start_time_field.addEventListener('change', update_start)
  end_date_field.addEventListener('change', update_end)
  end_time_field.addEventListener('change', update_end)

  setMinDate(start_date_field.value)
  update_start()
  update_end()
  end_time_field.value = start_time_field.value
}

const identifier = "_start_when"
const startsWhenFields = document.querySelectorAll(`input[id$=${identifier}]`);
startsWhenFields.forEach(field =>{
  const groupName = field.id.replace(identifier, '');
  groupedDateValidation(groupName)
})