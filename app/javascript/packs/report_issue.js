const clickoff = document.getElementById('clickoff')
const dialogue = document.getElementById("dialogue")
const btn_cancel = document.getElementById("cancel")
const text_body = document.getElementById("report_body")

clickoff.addEventListener('mouseup', CloseDialogue)
btn_cancel.addEventListener('mouseup', CloseDialogue)

function CloseDialogue(){
    dialogue.style.display="none"
    text_body.value=""
}