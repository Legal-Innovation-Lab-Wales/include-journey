const csrf_tokens = document.getElementsByName('csrf-token'),
    survey_url = `${location.origin}/${location.pathname.replace('/edit', '')}`,
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_details = document.querySelector('form#survey'),
    survey_fields = survey_details.querySelectorAll('input[name^=survey]'),
    survey_field_regexp = new RegExp(/survey\[(\w+)\]/),
    section_headings = document.querySelectorAll('input[name^=section]'),
    update_survey_fields = () => {
        const survey_data = [...survey_fields].map(field =>
            [field.getAttribute('name').match(survey_field_regexp)[1], field.value]),
            body = JSON.stringify({ survey: Object.fromEntries(new Map(survey_data)) })

        fetch(survey_url, { method: 'put', headers: headers, body: body })
            .then(response => { if (!response.ok) throw 'Survey details could not be updated!' })
            .catch(error => alert(error))
    },
    update_survey_heading = e => {
        const section_id = e.target.closest('.survey-section').dataset.id,
            body = JSON.stringify({ survey_section: { heading: e.target.value } })

        fetch(`${survey_url}/survey_sections/${section_id}`, { method: 'put', headers: headers, body: body })
            .then(response => { if (!response.ok) throw 'Survey section label could not be updated!' })
            .catch(error => alert(error))
    }

survey_fields.forEach(survey_field => survey_field.addEventListener('change', update_survey_fields))
section_headings.forEach(section_heading =>
    section_heading.addEventListener('change', update_survey_heading))