const csrf_tokens = document.getElementsByName('csrf-token'),
    headers = {'Content-Type': 'application/json', 'X-CSRF-Token': csrf_tokens.length > 0 ? csrf_tokens[0].content : ''},
    survey_url = `${location.origin}/${location.pathname.replace('/edit', '')}`,
    survey_sections = document.querySelectorAll('.survey-section')

survey_sections.forEach(survey_section => {
    survey_section.addEventListener('reorder', () => {
        const section_id = survey_section.dataset.id,
            questions = survey_section.querySelectorAll('.question'),
            comment_sections = survey_section.querySelectorAll('.comment-section')

        fetch(`${survey_url}/survey_sections/${section_id}/reorder`, {
            method: 'put',
            headers: headers,
            body: JSON.stringify({
                survey_section: {
                    questions: [...questions].map(question => question.dataset.questionId),
                    comment_sections: [...comment_sections].map(comment_section => comment_section.dataset.commentSectionId)
                }
            })
        })
            .then(response => {
                if (!response.ok) throw 'Section could not be reordered!'
                return response.json()
            })
            .catch(error => alert(error))
    })
})