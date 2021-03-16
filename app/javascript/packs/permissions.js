const checkboxes = document.querySelectorAll('input[type="checkbox"]')

function toggle(checkbox) {
    const label = checkbox.closest('div').querySelector('label'),
          icon = checkbox.closest('div').querySelector('i')

    if (checkbox.checked) {
        label.style['background-color'] = '#70A739'
        label.style['border-color'] = '#70A739'
        icon.classList.add('fa-check-circle')
        icon.classList.remove('fa-times-circle')
    } else {
        label.style['background-color'] = '#F32516'
        label.style['border-color'] = '#F32516'
        icon.classList.remove('fa-check-circle')
        icon.classList.add('fa-times-circle')
    }
}

checkboxes.forEach(checkbox => {
    checkbox.addEventListener('change', () => toggle(checkbox))
    toggle(checkbox)
})
