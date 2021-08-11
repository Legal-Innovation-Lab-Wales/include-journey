const csrf_tokens = document.getElementsByName('csrf-token'),
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_url = `${location.origin}/${location.pathname.replace('/edit', '')}`,
    questions = document.querySelectorAll('.row.question'),
    index = question => Array.from(question.parentNode.children).indexOf(question),
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
            const new_section_id = question.closest('.survey-section').dataset.id,
                orig_section_id = drag_src_el.dataset.sectionId,
                question_id = drag_src_el.dataset.questionId

            fetch(`${survey_url}/survey_sections/${orig_section_id}/survey_questions/${question_id}`, {
                method: 'put',
                headers: headers,
                body: JSON.stringify({ survey_question: { survey_section_id: new_section_id }})
            })
                .then(response => {
                    if (!response.ok) throw 'Survey Question could not be updated!'
                    return response.json()
                })
                .then(survey_question => {
                    drag_src_el.dataset.sectionId = survey_question.survey_section_id
                    question.insertAdjacentElement(drop_order > drag_order ? 'afterend' : 'beforebegin', drag_src_el)
                    reset_border(question)
                })
                .catch(error => alert(error))
        }
    })
})
