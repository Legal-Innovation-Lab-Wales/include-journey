const chart_wrapper = document.querySelector('#wellbeing-history-chart-carousel .carousel-inner'),
    slide_buttons = document.querySelectorAll('#wellbeing-history-chart-carousel button'),
    scale = [
        { description: "Abysmal", colour: "#E04444" },
        { description: "Dreadful", colour: "#E64D52" },
        { description: "Rubbish", colour: "#E86754" },
        { description: "Bad", colour: "#EC8754" },
        { description: "Mediocre", colour: "#F0A656" },
        { description: "Fine", colour: "#DFC54C" },
        { description: "Good", colour: "#BFCA48" },
        { description: "Great", colour: "#9ECB46" },
        { description: "Superb", colour: "#BFCB43" },
        { description: "Perfect", colour: "#5DAD3A" }
    ],
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
                            bounds: 'ticks',
                            source: 'auto'
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
                            max: 10,
                            stepSize: 1,
                            padding: 15,
                            callback: value => scale[value - 1].description
                        },
                        gridLines: {
                            drawBorder: false,
                            tickMarkLength: 0,
                            lineWidth: Array(10).fill(10),
                            color: scale.map(s => s.colour).reverse()
                        }
                    }]
                },
                tooltips: {
                    callbacks: {
                        label: (tooltipItem, data) =>
                            `${data.datasets[tooltipItem.datasetIndex].label}: ${scale[tooltipItem.yLabel - 1].description}`
                    }
                },
                legend: {
                    display: false
                }
            }
        })
    }

fetch(`${location}/wba_history`, {
    headers: {
        'Content-Type': 'application/json'
    }
})
.then(data => data.json())
.then(json => {
    json.datasets.forEach((dataset, index) => {
        const carousel_item = document.createElement('div')
        carousel_item.classList.add('carousel-item')
        if (index === 0) carousel_item.classList.add('active')

        const canvas = document.createElement('canvas')
        canvas.classList.add(`wellbeing-history-chart-${index}`)

        const heading = document.createElement('h4')
        heading.innerHTML = dataset.label

        carousel_item.append(heading)
        carousel_item.append(canvas)
        chart_wrapper.append(carousel_item)

        dataset.borderColor = '#1F77B4'
        dataset.lineTension = 0
        dataset.fill = false
        dataset.radius = 5
        dataset.hoverRadius = 6
        dataset.pointStyle = 'rectRounded'

        create_chart(canvas, {
            labels: json.labels,
            datasets: [dataset]
        })
    })

    slide_buttons.forEach(button => button.classList.remove('hidden'))
})