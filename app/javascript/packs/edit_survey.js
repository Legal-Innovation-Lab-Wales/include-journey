const csrf_tokens = document.getElementsByName('csrf-token'),
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_details = document.querySelector('form#survey'),
    survey_fields = survey_details.querySelectorAll('.form-control'),
    survey_name = survey_details.querySelector('input[name="survey[name]"]'),
    survey_start_date = survey_details.querySelector('input[name="survey[start_date]"]'),
    survey_end_date = survey_details.querySelector('input[name="survey[end_date]"]'),
    update_survey_fields = () => {
        fetch(`${location.origin}/${location.pathname.replace('/edit', '')}`, {
            method: 'put',
            headers: headers,
            body: JSON.stringify({
                survey: { name: survey_name.value, start_date: survey_start_date.value, end_date: survey_end_date.value }
            })
        })
            .then(response => { if (!response.ok) throw 'Survey details could not be updated!' })
            .catch(error => alert(error))
    }

survey_fields.forEach(survey_field => survey_field.addEventListener('change', update_survey_fields))
