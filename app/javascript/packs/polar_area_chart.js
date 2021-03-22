const wellbeing_charts = document.querySelectorAll('.wellbeing-chart'),
      sliders = document.querySelectorAll('.sliders'),
      scale = [{
          description: "Abysmal",
          colour: "#E04444"
      }, {
          description: "Dreadful",
          colour: "#E64D52"
      }, {
          description: "Rubbish",
          colour: "#E86754"
      }, {
          description: "Bad",
          colour: "#EC8754"
      }, {
          description: "Mediocre",
          colour: "#F0A656"
      }, {
          description: "Fine",
          colour: "#DFC54C"
      }, {
          description: "Good",
          colour: "#BFCA48"
      }, {
          description: "Great",
          colour: "#9ECB46"
      }, {
          description: "Superb",
          colour: "#BFCB43"
      }, {
          description: "Perfect",
          colour: "#5DAD3A"
      }]

wellbeing_charts.forEach((wellbeing_chart, index) => {
    if (!wellbeing_chart.classList.contains('chartjs-render-monitor')) {
        /*
         Here we are making the assertion that for every wellbeing chart there needs to be a corresponding slider
         section that houses the charts wellbeing scores.
         */
        const slider = sliders[index],
              inputs = slider.querySelectorAll('input[type="range"]'),
              labels = slider.querySelectorAll('label')

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
                        borderColor: '#F4E311'
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
            }

        if (!slider.classList.contains('d-none')) {
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
    }
})
