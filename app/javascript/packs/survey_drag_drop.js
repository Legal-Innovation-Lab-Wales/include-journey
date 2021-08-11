const draggable_rows = document.querySelectorAll('.row[draggable="true"]')

draggable_rows.forEach(draggable_row => {
    draggable_row.addEventListener('dragstart', () => draggable_row.style.opacity = 0.4)
    draggable_row.addEventListener('dragend', () => draggable_row.style.opacity = 1)
})