async function delete_note(elem) {
  let note_id = elem.parentElement.parentElement.getAttribute("id");
  let url = "http://localhost:3000/notes/" + note_id;
  fetch(url, {method: 'DELETE'})
    .then(response => response.json())
    .then(data => {
      if (data["deleted"]) {
        location.reload();
      } else {
        alert("Error when trying to delete note")
      }
    });
}