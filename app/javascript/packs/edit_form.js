const change_password = document.querySelector('.change-password'),
      confirm_password = document.querySelector('.confirm-password');

confirm_password.style.display = 'none';

change_password.addEventListener('click', () => {
  confirm_password.style.display = 'block';
});