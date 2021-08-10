const csrf_tokens = document.getElementsByName('csrf-token'),
    survey_url = `${location.origin}/${location.pathname.replace('/edit', '')}`,
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_details = document.querySelector('form#survey'),
    survey_fields = document.querySelectorAll('input[name^=survey]'),
    survey_name = survey_details.querySelector('input[name="survey[name]"]'),
    survey_start_date = survey_details.querySelector('input[name="survey[start_date]"]'),
    survey_end_date = survey_details.querySelector('input[name="survey[end_date]"]'),
    section_headings = document.querySelectorAll('input[name^=section]'),
    update_survey_fields = () => {
        fetch(survey_url, {
            method: 'put',
            headers: headers,
            body: JSON.stringify({
                survey: { name: survey_name.value, start_date: survey_start_date.value, end_date: survey_end_date.value }
            })
        })
            .then(response => { if (!response.ok) throw 'Survey details could not be updated!' })
            .catch(error => alert(error))
    },
    update_survey_heading = e => {
        const section_id = e.target.closest('.survey-section').dataset.id

        fetch(`${survey_url}/survey_sections/${section_id}`, {
            method: 'put',
            headers: headers,
            body: JSON.stringify({ survey_section: { heading: e.target.value } })
        })
            .then(response => { if (!response.ok) throw 'Survey section label could not be updated!' })
            .catch(error => alert(error))
    }

survey_fields.forEach(survey_field => survey_field.addEventListener('change', update_survey_fields))
section_headings.forEach(section_heading =>
    section_heading.addEventListener('change', update_survey_heading))