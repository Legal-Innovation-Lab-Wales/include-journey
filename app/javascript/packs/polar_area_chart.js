window.addEventListener('DOMContentLoaded',() => {
  const wellbeing_chart = document.getElementById('wellbeing-chart'),
        sliders = document.querySelectorAll('.sliders input'),
        // TODO: These can be stored against a DB record rather than hardcoded
        scale = [{
          description: "Abysmal",
          colour: "#E04444BF"
        },{
          description: "Dreadful",
          colour: "#E64D52BF"
        },{
          description: "Rubbish",
          colour: "#E86754BF"
        },{
          description: "Bad",
          colour: "#EC8754BF"
        },{
          description: "Mediocre",
          colour: "#F0A656BF"
        },{
          description: "Fine",
          colour: "#DFC54CBF"
        },{
          description: "Good",
          colour: "#BFCA48BF"
        },{
          description: "Great",
          colour: "#9ECB46BF"
        },{
          description: "Superb",
          colour: "#BFCB43BF"
        },{
          description: "Perfect",
          colour: "#5DAD3ABF"
        }]

  if (wellbeing_chart) {
    const chart = new Chart(wellbeing_chart.getContext('2d'), {
      type: 'polarArea',
      data: {
        datasets: [{
          data: [...sliders].map(input => input.value),
          backgroundColor: [...sliders].map(input => scale[input.value - 1].colour)
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
        },
        tooltips: {
          callbacks: {
            label: function(tooltipItem, data) {
              return `${data.labels[tooltipItem.index]}: ${scale[tooltipItem.yLabel - 1].description}`
            }
          }
        }
      }
    })

    sliders.forEach((input,index) => {
      input.addEventListener('change',() => {
        chart.data.datasets[0].data[index] = input.value
        chart.data.datasets[0].backgroundColor[index] = scale[input.value - 1].colour

        const description = input.closest('.row').querySelector('.description')
        description.innerText = scale[input.value - 1].description

        chart.update()
      })
    })
  }
})