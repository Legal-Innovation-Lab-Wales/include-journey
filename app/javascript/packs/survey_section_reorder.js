const csrf_tokens = document.getElementsByName('csrf-token'),
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_url = `${location.origin}/${location.pathname.replace('/edit', '')}`,
    survey_sections = document.querySelectorAll('.survey-section')

survey_sections.forEach(survey_section => {
    survey_section.addEventListener('reorder', () => {
        console.log('Reorder triggered!', survey_section.dataset.id)
    })
})