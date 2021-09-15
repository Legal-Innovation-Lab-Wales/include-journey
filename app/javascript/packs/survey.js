const radio_buttons = document.querySelectorAll('input[type="radio"]'),
      textareas = document.querySelectorAll('textarea'),
      headers = {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.getElementsByName('csrf-token').length > 0 ? document.getElementsByName('csrf-token')[0].content : ''
      },
      log_error = error => {
        console.error('Something Went Wrong.', error)
      },
      update = data => {
        fetch(`${location.origin}${location.pathname}`, {
            method: 'put', headers: headers, body: JSON.stringify(data)
        })
        .then(response => { if (!response.ok) log_error(response) })
        .catch(err => log_error(err))
      }

radio_buttons.forEach(radio_button => {
    radio_button.addEventListener('change', () => {
        const data = { partial: true, question: {}}
        data['question'][radio_button.dataset.id] = radio_button.value

        update(data)
    })
})

textareas.forEach(textarea => {
    textarea.addEventListener('change', () => {
        const data = { partial: true, comment_section: {}}
        data['comment_section'][textarea.dataset.id] = textarea.value

        update(data)
    })
})