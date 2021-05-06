const goal_modal = document.getElementById('goalModal'),
      container = goal_modal.querySelector('.container')

goal_modal.addEventListener('show.bs.modal', e => {
    const button = e.relatedTarget,
        goal_id = button.getAttribute('data-bs-goal-id'),
        goal_archived = button.getAttribute('data-bs-archived') === "true",
        goal_achieved = button.getAttribute('data-bs-achieved') === "true",
        goals_url = `/goals/${goal_id}`,
        achieve_url = `${goals_url}/achieve`,
        archive_url = `${goals_url}/archive`,
        achieve_btn = goal_modal.querySelector('.btn:first-child'),
        archive_btn = goal_modal.querySelector('.btn:nth-child(2)'),
        delete_btn = goal_modal.querySelector('.btn:last-child')

    achieve_btn.setAttribute('href', achieve_url)
    archive_btn.setAttribute('href', archive_url)
    delete_btn.setAttribute('href', goals_url)

    achieve_btn.dataset.method = 'put'
    archive_btn.dataset.method = 'put'
    delete_btn.dataset.method = 'delete'

    archive_btn.querySelector('.text').innerHTML = `${goal_archived ? 'Una' : 'A'}rchive`

    if (goal_achieved) {
        achieve_btn.classList.add('d-none')
        container.classList.add('two')
    } else {
        achieve_btn.classList.remove('d-none')
        container.classList.remove('two')
    }
})