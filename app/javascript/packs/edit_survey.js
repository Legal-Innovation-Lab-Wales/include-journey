const csrf_tokens = document.getElementsByName('csrf-token'),
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_details = document.querySelector('form#survey'),
    survey_fields = survey_details.querySelectorAll('.form-control'),
    update_survey_fields = () => {
    }

survey_fields.forEach(survey_field => {
    survey_field.addEventListener('change', () => {

    })
})