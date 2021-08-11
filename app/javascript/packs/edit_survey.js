const csrf_tokens = document.getElementsByName('csrf-token'),
    survey_url = `${location.origin}/${location.pathname.replace('/edit', '')}`,
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_fields = document.querySelectorAll('input[name^=survey]'),
    section_headings = document.querySelectorAll('input[name^=section]'),
    questions = document.querySelectorAll('input[name^=question]'),
    regexp = type => { return new RegExp(`${type}\\[(\\w+)\\]`) },
    section_id = e => e.target.closest('.survey-section').dataset.id,
    update_survey_fields = () => {
        const survey_data = [...survey_fields].map(field => [field.name.match(regexp('survey'))[1], field.value]),
            body = JSON.stringify({ survey: Object.fromEntries(new Map(survey_data)) })

        fetch(survey_url, { method: 'put', headers: headers, body: body })
            .then(response => { if (!response.ok) throw 'Survey details could not be updated!' })
            .catch(error => alert(error))
    },
    update_survey_heading = e => {
        fetch(`${survey_url}/survey_sections/${section_id(e)}`, {
            method: 'put', headers: headers, body: JSON.stringify({ survey_section: { heading: e.target.value } })
        })
            .then(response => { if (!response.ok) throw 'Survey section label could not be updated!' })
            .catch(error => alert(error))
    },
    update_question = e => {
        fetch(`${survey_url}/survey_sections/${section_id(e)}/survey_questions/${e.target.dataset.id}`, {
            method: 'put', headers: headers, body: JSON.stringify( { survey_question: { question: e.target.value } })
        })
            .then(response => { if (!response.ok) throw 'Survey question could not be updated!' })
            .catch(error => alert(error))
    }

survey_fields.forEach(survey_field => survey_field.addEventListener('change', update_survey_fields))
section_headings.forEach(section_heading =>
    section_heading.addEventListener('change', update_survey_heading))
questions.forEach(question => question.addEventListener('change', update_question))