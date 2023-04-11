const visible_to_user_checkbox = document.getElementById('visible-to-user'),
    submit_button = document.getElementById('submit');

visible_to_user_checkbox.addEventListener('change', () => {
    visible_to_user_checkbox.checked ? submit_button.dataset.confirm = 'You are about to make this note visible to the user, are you sure you wish to proceed?' : submit_button.removeAttribute('data-confirm')
})