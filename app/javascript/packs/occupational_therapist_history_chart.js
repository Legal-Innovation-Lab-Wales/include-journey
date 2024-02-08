const carousel = document.querySelector('#occupational-therapist-history-chart-carousel'),
    resources = document.getElementById('occupational-therapist-history-chart-carousel'),
    chart_wrapper = carousel.querySelector('.carousel-inner'),
    slide_buttons = carousel.querySelectorAll('button'),
    metric_select = carousel.querySelector('select'),
    indicators = carousel.querySelector('.carousel-indicators'),
    scale = JSON.parse(resources.dataset.scale),
    create_chart = (history_chart, data) => {
        new Chart(history_chart.getContext('2d'), {
            type: 'line',
            data: data,
            options: {
                scales: {
                    xAxes: [{
                        type: 'time',
                        time: {
                            tooltipFormat: 'MMMM Do YYYY',
                            displayFormats: {
                                day: 'Do MMM YY'
                            }
                        },
                        ticks: {
                            autoSkip: true,
                            maxTicksLimit: 11

                        },
                        gridLines: {
                            zeroLineColor: 'gray',
                            color: 'gray'
                        },
                    }],
                    yAxes: [{
                        offset: true,
                        ticks: {
                            min: 1,
                            max: 6,
                            stepSize: 1,
                            padding: 15,
                            callback: tick_value => scale[tick_value - 1].value
                        },
                        gridLines: {
                            drawBorder: false,
                            lineWidth: Array(10).fill(10),
                        }
                    }]
                },
                tooltips: {
                    callbacks: {
                        label: (tooltipItem, data) =>
                            `${data.datasets[tooltipItem.datasetIndex].label}: ${scale[tooltipItem.yLabel - 1].value}`
                    }
                },
                legend: {
                    display: false
                },
                spanGaps: true
            }
        })
    },
    toggle_active = (parent, event, css_selector) => {
        parent.querySelector('.active').classList.remove('active')
        parent.querySelectorAll(css_selector)[event.target.value].classList.add('active')
    }
fetch(`${location.origin}${location.pathname}/ota_history`, {
    headers: {
        'Content-Type': 'application/json'
    }
})
    .then(data => data.json())
    .then(json => {
        [...chart_wrapper.children].forEach(child => child.remove());
        [...metric_select.children].forEach(child => child.remove());
        [...indicators.children].forEach(child => child.remove());

        json.datasets.forEach((dataset, index) => {
            const carousel_item = document.createElement('div')
            carousel_item.classList.add('carousel-item')
            if (index === 0) carousel_item.classList.add('active')

            const canvas = document.createElement('canvas')
            canvas.classList.add(`occupational-therapist-history-chart-${index}`)

            const option = document.createElement('option')
            option.setAttribute('value', index)
            option.innerHTML = dataset.label

            const indicator = document.createElement('button')
            indicator.setAttribute('type', 'button')
            indicator.setAttribute('type', 'button')
            indicator.dataset.bsTarget = '#occupational-therapist-history-chart-carousel'
            indicator.dataset.bsSlideTo = index
            indicator.dataset.toggle = 'tooltip'
            indicator.setAttribute('title', dataset.label)
            if (index === 0) indicator.classList.add('active')
            if (index === 0) indicator.setAttribute('aria-current', 'true')
            indicator.setAttribute('aria-label', dataset.label)

            indicators.append(indicator)
            metric_select.append(option)
            carousel_item.append(canvas)
            chart_wrapper.append(carousel_item)

            dataset.borderColor = '#1F77B4'
            dataset.lineTension = 0
            dataset.fill = false
            dataset.radius = 2
            dataset.hoverRadius = 10
            dataset.pointStyle = 'rectRounded'

            create_chart(canvas, {
                labels: json.labels,
                datasets: [dataset]
            })
        })

        slide_buttons.forEach(button => button.classList.remove('hidden'))
    })

metric_select.addEventListener('change', e => {
    toggle_active(chart_wrapper, e, '.carousel-item')
    toggle_active(indicators, e, 'button')
})

carousel.addEventListener('slid.bs.carousel', e => metric_select.value = e.to)
