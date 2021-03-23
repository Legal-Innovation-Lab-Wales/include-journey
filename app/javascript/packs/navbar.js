const buttons = document.querySelectorAll('.navbar .btn')

buttons.forEach(btn => {
    const label = btn.querySelector('.nav-label')
    btn.addEventListener('mouseenter', () => {
        label.classList.add('show')
        label.classList.remove('hide')
    })
    btn.addEventListener('mouseleave', () => {
        label.classList.remove('show')
        label.classList.add('hide')
    })
})
