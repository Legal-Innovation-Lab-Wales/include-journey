window.addEventListener('DOMContentLoaded', () => {
  const wellbeing_chart = document.getElementById('wellbeing-chart'),
        sliders = document.querySelectorAll('.sliders input')

  if (wellbeing_chart) {
    const chart = new Chart(wellbeing_chart.getContext('2d'), {
      type: 'polarArea',
      data: {
        datasets: [{
          data: [...sliders].map(input => input.value)
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
            stepSize: 1
          }
        },
        animation: {
          animateRotate: false
        }
      }
    })

    sliders.forEach((input, index) => {
      input.addEventListener('change', () => {
        chart.data.datasets[0].data[index] = input.value
        chart.update()
      })
    })
  }
})