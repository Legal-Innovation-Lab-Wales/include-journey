const wellbeing_services = document.querySelectorAll('.wellbeing-service'),
      toggle_service = (slider, service) => {
        // Less than or equal to 'mediocre'
        if (slider.value <= 5) {
            service.classList.add('show')
            slider.setAttribute('data-low',true)
        } else {
            slider.setAttribute('data-low',false)
        }
        CheckService(service)
      }
      

if (wellbeing_services) {
    wellbeing_services.forEach(wellbeing_service => {
        const linked_metrics = JSON.parse(wellbeing_service.dataset.metrics)
        wellbeing_service.setAttribute('data-counter',0)
        linked_metrics.forEach(linked_metric => {
            const slider = document.querySelector(`input[id$="${linked_metric}"][type="range"]`)

            slider.addEventListener('change', () => toggle_service(slider, wellbeing_service))
            toggle_service(slider, wellbeing_service)
        })
    })
}

function CheckService(service){
    const linked_metrics = JSON.parse(service.dataset.metrics)
    let show = false
    linked_metrics.forEach(linked_metric => {
        const slider = document.querySelector(`input[id$="${linked_metric}"][type="range"]`)
        if(slider.getAttribute('data-low')=='true'){
            show=true;
        }
    })
    if(!show){
        service.classList.remove('show')
    }
}