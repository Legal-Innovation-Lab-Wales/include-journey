const csrf_tokens = document.getElementsByName('csrf-token'),
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_url = `${location.origin}/${location.pathname.replace('/edit', '')}`,
    question_rows = document.querySelectorAll('.row.question'),
    comment_section_rows = document.querySelectorAll('.row.comment-section'),
    index = row => Array.from(row.parentNode.children).indexOf(row),
    reset_border = row => row.classList.remove('drop-border-bottom', 'drop-border-top'),
    reorder = new Event('reorder')

let drag_row = null

const setup_row_drag_drop = (rows, resource_type) => {
    rows.forEach(row => {
        row.addEventListener('dragstart', () => {
            row.style.opacity = 0.4
            drag_row = row
        })
        row.addEventListener('dragend', () => row.style.opacity = 1)
        row.addEventListener('dragenter', e => e.preventDefault())
        row.addEventListener('dragover', e => {
            e.preventDefault()
            if (drag_row.dataset.resourceType === row.dataset.resourceType && drag_row !== row) {
                const drag_order = index(drag_row), drop_order = index(row)
                row.classList.add(`drop-border-${drop_order > drag_order ? 'bottom' : 'top'}`)
            }
        })
        row.addEventListener('dragleave', () => reset_border(row))
        row.addEventListener('drop', e => {
            e.preventDefault()
            if (drag_row.dataset.resourceType === row.dataset.resourceType && drag_row !== row) {
                const drag_order = index(drag_row),
                    drop_order = index(row),
                    drag_section = drag_row.closest('.survey-section'),
                    drop_section = row.closest('.survey-section'),
                    drag_section_id = drag_section.dataset.id,
                    drop_section_id = drop_section.dataset.id,
                    resourceId = drag_row.dataset.resourceId

                const data = {}
                data[`survey_${resource_type}`] = {survey_section_id: drop_section_id}

                fetch(`${survey_url}/survey_sections/${drag_section_id}/survey_${resource_type}s/${resourceId}`, {
                    method: 'put',
                    headers: headers,
                    body: JSON.stringify(data)
                })
                    .then(response => {
                        if (!response.ok) throw `Survey ${resource_type.split('_').join(' ')} could not be updated!`
                        return response.json()
                    })
                    .then(survey_question => {
                        drag_row.dataset.sectionId = survey_question.survey_section_id
                        row.insertAdjacentElement(drop_order > drag_order ? 'afterend' : 'beforebegin', drag_row)
                        reset_border(row)

                        if (drag_section_id !== drop_section_id) drag_section.dispatchEvent(reorder)
                        drop_section.dispatchEvent(reorder)
                    })
                    .catch(error => alert(error))
            }
        })
    })
}

setup_row_drag_drop(question_rows, 'question')
setup_row_drag_drop(comment_section_rows, 'comment_section')
