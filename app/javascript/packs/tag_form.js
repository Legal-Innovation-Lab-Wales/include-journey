const tag_input_switches = document.querySelectorAll('.tag .input-switch'),
      clear_inputs = (select, text) => {
          select.value = ''
          select.querySelectorAll('option').forEach(option => {
              if (option.value === '') {
                  option.setAttribute('selected', 'true')
              } else {
                  option.removeAttribute('selected')
              }
          })
          text.value = ''
      }

tag_input_switches.forEach(tag_input_switch => {
    tag_input_switch.addEventListener('click', () => {
        const inputs = tag_input_switch.closest('div'),
              select = inputs.querySelector('select'),
              text = inputs.querySelector('input[type="text"]')

        clear_inputs(select, text)

        if (tag_input_switch.classList.contains('fa-pencil-alt')) {
            select.classList.add('d-none')
            select.removeAttribute('required')

            text.classList.remove('d-none')
            text.setAttribute('required', 'true')

            tag_input_switch.classList.remove('fa-pencil-alt')
            tag_input_switch.classList.add('fa-list-ul')
        } else {
            text.classList.add('d-none')
            text.removeAttribute('required')

            select.classList.remove('d-none')
            select.setAttribute('required', 'true')

            tag_input_switch.classList.remove('fa-list-ul')
            tag_input_switch.classList.add('fa-pencil-alt')
        }
    })
})
