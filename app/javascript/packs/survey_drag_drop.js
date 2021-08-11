const questions = document.querySelectorAll('.row.question'),
    index = question => Array.from(question.parentNode.children).indexOf(question)
    reset_border = question => question.classList.remove('drop-border-bottom', 'drop-border-top')

let drag_src_el = null

questions.forEach(question => {
    question.addEventListener('dragstart', e => {
        question.style.opacity = 0.4
        drag_src_el = question
    })
    question.addEventListener('dragend', () => question.style.opacity = 1)
    question.addEventListener('dragenter', e => e.preventDefault())
    question.addEventListener('dragover', e => {
        e.preventDefault()
        const drag_order = index(drag_src_el), drop_order = index(question)
        if (drop_order !== drag_order)
            question.classList.add(`drop-border-${drop_order > drag_order ? 'bottom' : 'top'}`)
    })
    question.addEventListener('dragleave', () => reset_border(question))
    question.addEventListener('drop', e => {
        e.preventDefault()
        const drag_order = index(drag_src_el), drop_order = index(question)
        if (drop_order !== drag_order) {
            question.insertAdjacentElement(drop_order > drag_order ? 'afterend' : 'beforebegin', drag_src_el)
            reset_border(question)
        }
    })
})
