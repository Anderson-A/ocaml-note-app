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

async function save_note(elem) {
  let note_id = elem.parentElement.getAttribute("id");
  let note_title = document.getElementById("title_input").value;
  let note_content = document.getElementById("content_input").value;

  if (note_title.length < 1) {
    alert("Note title must be non-empty!");
    return;
  }

  let url = "http://localhost:3000/notes/" + note_id
    + "?title=" + note_title
    + "&content=" + note_content;

  fetch(url, {method: 'PUT'})
    .then(response => response.json())
    .then(data => {
      if (data["updated"]) {
        alert("Note saved");
      } else {
        alert("Error when trying to save note");
      }
    });
}