const permissionsModal = document.querySelector('#permissionsModal')

if (permissionsModal) {
    document.body.classList.add('modal-open')

    permissionsModal.addEventListener('click', e => {
        if (e.target === permissionsModal) {
            permissionsModal.classList.add('modal-static')
            setTimeout(() => permissionsModal.classList.remove('modal-static'), 500)
        }
    })
}