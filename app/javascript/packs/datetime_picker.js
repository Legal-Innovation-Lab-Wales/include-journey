const groupedDateValidation = (name) => {
  const date_field = document.querySelector(`#${name}_when`),
      time_field = document.querySelector(`#${name}_time`),
      hidden_field = document.querySelector(`#${name}`),
      update_start = () => {
          hidden_field.value = new Date(`${date_field.value} ${time_field.value}`)
      }
  date_field.addEventListener('change', update_start)
  time_field.addEventListener('change', update_start)

  update_start()
}

const identifier = "_when"
const startsWhenFields = document.querySelectorAll(`input[id$=${identifier}]`);
startsWhenFields.forEach(field =>{
  const groupName = field.id.replace(identifier, '');
  groupedDateValidation(groupName)
})