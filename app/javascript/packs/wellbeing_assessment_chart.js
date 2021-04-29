const wellbeing_charts = document.querySelectorAll('.wellbeing-chart.wrapper'),
      scale = [
          { description: "Abysmal", colour: "#E04444" },
          { description: "Dreadful", colour: "#e66043" },
          { description: "Rubbish", colour: "#eb7945" },
          { description: "Bad", colour: "#ee904b" },
          { description: "Mediocre", colour: "#F0A656" },
          { description: "Fine", colour: "#DFC54C" },
          { description: "Good", colour: "#c1c041" },
          { description: "Great", colour: "#a2ba3a" },
          { description: "Superb", colour: "#82b438" },
          { description: "Perfect", colour: "#5DAD3A" }
      ],
      classes = [...Array(10).keys()].map(i => `wba-score__${i+1}`)

wellbeing_charts.forEach(wellbeing_chart_wrapper => {
    const wellbeing_chart = wellbeing_chart_wrapper.querySelector('.wellbeing-chart')

    if (!wellbeing_chart.classList.contains('chartjs-render-monitor')) {
        const slider = wellbeing_chart_wrapper.querySelector('.sliders'),
              labels = slider.querySelectorAll('label'),
              inputs = slider.querySelectorAll('input[type="range"]')

        const chart = new Chart(wellbeing_chart.getContext('2d'), {
            type: 'polarArea',
            data: {
                datasets: [{
                    data: [...inputs].map(input => input.value),
                    backgroundColor: [...inputs].map(input => scale[input.value - 1].colour)
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
                            return `${data.labels[tooltipItem.index]}: ${scale[tooltipItem.yLabel - 1].description}`
                        }
                    }
                }
            }
            }),
            setDescription = function (input) {
                // The description field is only relevant when a the wellbeing charts sliders are visible.
                const description = input.closest('.row').querySelector('.description')
                description.innerText = scale[input.value - 1].description

                description.classList.remove(...classes)
                description.classList.add(`wba-score__${input.value}`)
            }

        inputs.forEach((input, index) => {
            input.addEventListener('change', () => {
                chart.data.datasets[0].data[index] = input.value
                chart.data.datasets[0].backgroundColor[index] = scale[input.value - 1].colour
                setDescription(input)

                chart.update()
            })

            setDescription(input)
        })
    }
})
