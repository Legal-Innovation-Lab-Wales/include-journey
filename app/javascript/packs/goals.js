const short_term_add = document.querySelector('.short-term .add'),
      short_term_form = document.querySelector('.short-term form'),
      short_term_cancel = document.querySelector('.short-term .cancel'),
      long_term_add = document.querySelector('.long-term .add'),
      long_term_form = document.querySelector('.long-term form'),
      long_term_cancel = document.querySelector('.long-term .cancel'),
      toggle_form = (e, form, add) => {
          e.preventDefault()
          add.classList.toggle('hidden')
          form.classList.toggle('hidden')
      },
      goal_modal = document.getElementById('goalModal'),
      container = goal_modal.querySelector('.container')

short_term_add.addEventListener('click', e => toggle_form(e, short_term_form, short_term_add))
long_term_add.addEventListener('click', e => toggle_form(e, long_term_form, long_term_add))
short_term_cancel.addEventListener('click', e => toggle_form(e, short_term_form, short_term_add))
long_term_cancel.addEventListener('click', e => toggle_form(e, long_term_form, long_term_add))

goal_modal.addEventListener('show.bs.modal', e => {
    const button = e.relatedTarget,
          goal_id = button.getAttribute('data-bs-goal-id'),
          goal_achieved = button.getAttribute('data-bs-achieved') === "true",
          goals_url = `/goals/${goal_id}`,
          achieve_url = `${goals_url}/achieve`,
          archive_url = `${goals_url}/archive`,
          achieve_btn = goal_modal.querySelector('.btn:first-child'),
          archive_btn = goal_modal.querySelector('.btn:nth-child(2)'),
          delete_btn = goal_modal.querySelector('.btn:last-child')

    achieve_btn.setAttribute('href', achieve_url)
    achieve_btn.dataset.method = 'put'

    archive_btn.setAttribute('href', archive_url)
    delete_btn.setAttribute('href', goals_url)

    archive_btn.dataset.method = 'put'
    delete_btn.dataset.method = 'delete'

    if (goal_achieved) {
        achieve_btn.classList.add('d-none')
        container.classList.add('two')
    } else {
        achieve_btn.classList.remove('d-none')
        container.classList.remove('two')
    }
})