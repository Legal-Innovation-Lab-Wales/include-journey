const wellbeing_charts = document.querySelectorAll('.wellbeing-chart.wrapper'),
      resources = document.getElementById('chart-wrapper'),
      scale = JSON.parse(resources.dataset.scale),
      classes = [...Array(10).keys()].map(i => `wba-score__${i+1}`)

wellbeing_charts.forEach(wellbeing_chart_wrapper => {
    const wellbeing_chart = wellbeing_chart_wrapper.querySelector('.wellbeing-chart'),
          slider = wellbeing_chart_wrapper.querySelector('.sliders'),
          labels = slider.querySelectorAll('label'),
          inputs = slider.querySelectorAll('input[type="range"]')

    const chart = new Chart(wellbeing_chart.getContext('2d'), {
        type: 'polarArea',
        data: {
            datasets: [{
                data: [...inputs].map(input => input.value),
                backgroundColor: [...inputs].map(input => scale[input.value - 1].color)
            }],
            labels: [...labels].map(label => label.innerText.trim())
        },
        options: {
            elements: {
                arc: {
                    borderColor: '#FADE0A'
                }
            },
            legend: {
                display: false
            },
            scale: {
                ticks: {
                    max: 10,
                    min: 0,
                    stepSize: 1,
                    display: false
                }
            },
            animation: {
                animateRotate: false
            },
            tooltips: {
                callbacks: {
                    label: function (tooltipItem, data) {
                        return `${data.labels[tooltipItem.index]}: ${scale[tooltipItem.yLabel - 1].name}`
                    }
                }
            }
        }
        }),
        setDescription = function (input) {
            // The description field is only relevant when a the wellbeing charts sliders are visible.
            const description = input.closest('.row').querySelector('.description')
            description.innerText = scale[input.value - 1].name

            description.classList.remove(...classes)
            description.classList.add(`wba-score__${input.value}`)
        }

    inputs.forEach((input, index) => {
        input.addEventListener('change', () => {
            chart.data.datasets[0].data[index] = input.value
            chart.data.datasets[0].backgroundColor[index] = scale[input.value - 1].color
            setDescription(input)

            chart.update()
        })
    })
})
