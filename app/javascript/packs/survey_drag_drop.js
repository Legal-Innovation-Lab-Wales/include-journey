const csrf_tokens = document.getElementsByName('csrf-token'),
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_url = `${location.origin}/${location.pathname.replace('/edit', '')}`,
    sections = document.querySelectorAll('.row.section'),
    questions = document.querySelectorAll('.row.question'),
    comment_sections = document.querySelectorAll('.row.comment-section'),
    reorder = new Event('reorder'),
    index = resource => {
        if (resource.classList.contains('section')) {
            return Array.from(resource.parentNode.parentNode.children).indexOf(resource.parentNode)
        } else {
            return Array.from(resource.parentNode.children).indexOf(resource)
        }
    },
    reset_border = resource => resource.classList.remove('drop-border-bottom', 'drop-border-top'),
    can_drop = (drag, drop) => drag !== drop && drag.dataset.type === drop.dataset.type,
    drop_row = row => {
        const drag_section = drag.parentNode,
            drop_section = row.parentNode,
            drag_section_id = drag_section.dataset.id,
            drop_section_id = drop_section.dataset.id

        const data = {}
        data[`survey_${row.dataset.type}`] = {survey_section_id: drop_section_id}

        fetch(`${survey_url}/survey_sections/${drag_section_id}/survey_${row.dataset.type}s/${drag.dataset.resourceId}`, {
            method: 'put',
            headers: headers,
            body: JSON.stringify(data)
        })
            .then(response => {
                if (!response.ok) throw `Survey ${row.dataset.type.split('_').join(' ')} could not be updated!`
                return response.json()
            })
            .then(survey_question => {
                drag.dataset.sectionId = survey_question.survey_section_id
                row.insertAdjacentElement(index(row) > index(drag) ? 'afterend' : 'beforebegin', drag)
                reset_border(row)

                if (drag_section_id !== drop_section_id) drag_section.dispatchEvent(reorder)
                drop_section.dispatchEvent(reorder)
            })
            .catch(error => alert(error))
    },
    drop_section = section => {
        section.parentNode.insertAdjacentElement(index(section) > index(drag) ? 'afterend' : 'beforebegin', drag.parentNode)
        reset_border(section)
        section.parentNode.parentNode.dispatchEvent(reorder)
    }

let drag = null

const setup_drag_drop = resources => {
    resources.forEach(resource => {
        resource.addEventListener('dragstart', () => {
            resource.style.opacity = 0.4
            drag = resource
        })
        resource.addEventListener('dragend', () => resource.style.opacity = 1)
        resource.addEventListener('dragenter', e => e.preventDefault())
        resource.addEventListener('dragover', e => {
            e.preventDefault()
            if (can_drop(drag, resource))
                resource.classList.add(`drop-border-${index(resource) > index(drag) ? 'bottom' : 'top'}`)
        })
        resource.addEventListener('dragleave', () => reset_border(resource))
        resource.addEventListener('drop', e => {
            e.preventDefault()
            if (can_drop(drag, resource))
                resource.classList.contains('section') ? drop_section(resource) : drop_row(resource)
        })
    })
}

setup_drag_drop(questions)
setup_drag_drop(comment_sections)
setup_drag_drop(sections)
