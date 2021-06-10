const wellbeing_services = document.querySelectorAll('.wellbeing-service'),
      toggle_service = (slider, service) => {
        // Less than or equal to 'mediocre'
        if (slider.value <= 5) {
            service.classList.add('show')
        } else {
            service.classList.remove('show')
        }
      }

if (wellbeing_services) {
    wellbeing_services.forEach(wellbeing_service => {
        const linked_metrics = JSON.parse(wellbeing_service.dataset.metrics)

        linked_metrics.forEach(linked_metric => {
            const slider = document.querySelector(`input[id$="${linked_metric}"][type="range"]`)

            slider.addEventListener('change', () => toggle_service(slider, wellbeing_service))
            toggle_service(slider, wellbeing_service)
        })
    })
}