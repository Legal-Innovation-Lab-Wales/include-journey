const csrf_tokens = document.getElementsByName('csrf-token'),
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_url = `${location.origin}/${location.pathname.replace('/edit', '')}`,
    survey = document.querySelector('.col.survey'),
    survey_sections = survey.querySelectorAll('.survey-section'),
    resource_map = resources => [...resources].map(resource => resource.dataset.resourceId)

survey_sections.forEach(survey_section => {
    survey_section.addEventListener('reorder', () => {
        const section_id = survey_section.dataset.id,
            questions = survey_section.querySelectorAll('.question'),
            comment_sections = survey_section.querySelectorAll('.comment-section')

        fetch(`${survey_url}/survey_sections/${section_id}/reorder`, {
            method: 'put',
            headers: headers,
            body: JSON.stringify({
                survey_section: { questions: resource_map(questions), comment_sections: resource_map(comment_sections) }
            })
        })
            .then(response => {
                if (!response.ok) throw 'Section could not be reordered!'
                return response.json()
            })
            .catch(error => alert(error))
    })
})

survey.addEventListener('reorder', () => {
    const survey_sections = survey.querySelectorAll('.survey-section .section')

    fetch(`${survey_url}/reorder`, {
        method: 'put',
        headers: headers,
        body: JSON.stringify({
            survey: { sections: resource_map(survey_sections) }
        })
    })
        .then(response => {
            if (!response.ok) throw 'Survey could not be reordered!'
            return response.json()
        })
        .catch(error => alert(error))
})