const checkboxes = document.querySelectorAll('input[type="checkbox"]')

function toggle(checkbox) {
    const label = checkbox.closest('div').querySelector('label'),
          icon = checkbox.closest('div').querySelector('i')

    label.classList.toggle('selected')
    icon.classList.toggle('fa-check-circle')
    icon.classList.toggle('fa-times-circle')
}

checkboxes.forEach(checkbox => {
    checkbox.addEventListener('change', () => toggle(checkbox))
})
