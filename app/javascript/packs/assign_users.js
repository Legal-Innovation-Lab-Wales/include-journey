const approveButtons = document.querySelectorAll(".approve-button");
const assignSelectedButton = document.querySelector(".assign-selected-button");
const form = document.querySelector("form#assign-users-form")

approveButtons.forEach(function (button) {
  button.addEventListener("click", function (event) {
    event.preventDefault();
    const submitUrl = this.dataset['submitUrl'];
    form.setAttribute("action", submitUrl);
    form.submit();
  });
});

assignSelectedButton.addEventListener("click", function (event) {
  event.preventDefault();
  // The form already has the correct action URL set, so directly submit it
  form.submit();
});
