// called when edit note button is clicked
window.gareth = function(userId, noteId) {
  console.log(userId)
  console.log(noteId);
  fetchNote(userId, noteId)
}

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