const wellbeing_chart = document.getElementById('wellbeing-history'),
      sliders = document.querySelectorAll('.sliders input[type="range"]'),
      wbaSelves = document.querySelectorAll('.history-metrics input[type="range"]'),

      hasRendered = function() {
          return wellbeing_chart.classList.contains('chartjs-render-monitor')
      }

if (wellbeing_chart && !hasRendered()) {
    const chart = new Chart(wellbeing_chart.getContext('2d'), {
        type: 'line',
        data: {
            datasets: [{
                data: [...wbaSelves],
            }],
            labels: [...sliders].map(input => document.querySelector(`label[for="${input.id}"]`).innerText)
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
    })
}