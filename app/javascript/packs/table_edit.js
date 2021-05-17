const edit_btns = document.querySelectorAll('table .fa-edit'),
      cancel_btns = document.querySelectorAll('table .cancel')

edit_btns.forEach(edit_btn => {
    edit_btn.addEventListener('click', () => {
        const row = edit_btn.closest('tr'),
            inputs = row.querySelectorAll('input[type="text"]'),
            submit_btn = row.querySelector('input[type="submit"]'),
            cancel_btn = row.querySelector('.cancel')

        edit_btn.classList.add('hidden')
        submit_btn.classList.remove('hidden')
        cancel_btn.classList.remove('hidden')
        inputs.forEach((input, index) => {
            input.removeAttribute('disabled')
            if (index === 0) input.focus()
        })
    })
})

cancel_btns.forEach(cancel_btn => {
    cancel_btn.addEventListener('click', () => {
        const row = cancel_btn.closest('tr'),
            inputs = row.querySelectorAll('input[type="text"]'),
            submit_btn = row.querySelector('input[type="submit"]'),
            edit_btn = row.querySelector('.fa-edit')

        edit_btn.classList.remove('hidden')
        submit_btn.classList.add('hidden')
        cancel_btn.classList.add('hidden')
        inputs.forEach((input, index) =>
            input.setAttribute('disabled', ''))
    })
})