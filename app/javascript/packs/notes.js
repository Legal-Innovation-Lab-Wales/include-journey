const edit_btns = document.querySelectorAll('.edit-btn')

edit_btns.forEach(edit_btn => {
    edit_btn.addEventListener('click', () => {
        console.log(edit_btn.dataset.userId)
        console.log(edit_btn.dataset.noteId);
        fetchNote(edit_btn.dataset.userId, edit_btn.dataset.noteId)
    })
})

function fetchNote(userId, noteId) {
  url = `localhost:3000/users/${userId}/notes/${noteId}/edit`;
  fetch(url)
    .then(response => {
      // handle the response
      console.log(response);
    })
    .catch(error => {
        // handle the error
        console.log(error);
    });
  console.log("Hello World")
}