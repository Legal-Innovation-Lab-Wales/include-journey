const csrf_tokens = document.getElementsByName('csrf-token'),
    survey_url = `${location.origin}${location.pathname.replace('/edit', '')}`,
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_fields = document.querySelectorAll('input[name^=survey]'),
    section_headings = document.querySelectorAll('input[name^=section]'),
    questions = document.querySelectorAll('input[name^=question]'),
    comment_sections = document.querySelectorAll('input[name^=comment_section]'),
    section_id = e => e.target.closest('.survey-section').dataset.id,
    update_survey_fields = () => {
        const survey_data = [...survey_fields].map(field => [field.dataset.name, field.value]),
            body = JSON.stringify({ survey: Object.fromEntries(new Map(survey_data)) })

        fetch(survey_url, { method: 'put', headers: headers, body: body })
            .then(response => { if (!response.ok) throw 'Survey details could not be updated!' })
            .catch(error => alert(error))
    },
    update_survey_heading = e => {
        fetch(`${survey_url}/survey_sections/${section_id(e)}`, {
            method: 'put', headers: headers, body: JSON.stringify({ survey_section: { heading: e.target.value } })
        })
            .then(response => { if (!response.ok) throw 'Survey Section label could not be updated!' })
            .catch(error => alert(error))
    },
    update_question = e => {
        fetch(`${survey_url}/survey_sections/${section_id(e)}/survey_questions/${e.target.dataset.id}`, {
            method: 'put', headers: headers, body: JSON.stringify( { survey_question: { question: e.target.value } })
        })
            .then(response => { if (!response.ok) throw 'Survey Question could not be updated!' })
            .catch(error => alert(error))
    },
    update_comment_section = e => {
        fetch(`${survey_url}/survey_sections/${section_id(e)}/survey_comment_sections/${e.target.dataset.id}`, {
            method: 'put', headers: headers, body: JSON.stringify( { survey_comment_section: { label: e.target.value } })
        })
            .then(response => { if (!response.ok) throw 'Survey Comment Section label could not be updated!' })
            .catch(error => alert(error))
    }

survey_fields.forEach(survey_field => survey_field.addEventListener('change', update_survey_fields))
section_headings.forEach(section_heading => section_heading.addEventListener('change', update_survey_heading))
questions.forEach(question => question.addEventListener('change', update_question))
comment_sections.forEach(comment_section => comment_section.addEventListener('change', update_comment_section))