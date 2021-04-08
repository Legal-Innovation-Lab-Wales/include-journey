const scale = [
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
]

fetch(`${location}/wba_history`, {
    headers: {
        'Content-Type': 'application/json'
    }
})
.then(data => data.json())
.then(json => {
    const colours = [
        '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b',
        '#e377c2', '#7f7f7f', '#bcbd22', '#17becf', '#7570b3'
    ]

    json.datasets.forEach((dataset, index) => {
        dataset.borderColor = colours[index]
        dataset.lineTension = 0
        dataset.fill = false
        dataset.hidden = index > 0
        dataset.radius = 5
        dataset.hoverRadius = 6
        dataset.pointStyle = 'rectRounded'
    })

    const history_chart = document.querySelector('#wellbeing-history-chart')

    new Chart(history_chart.getContext('2d'), {
        type: 'line',
        data: json,
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
                        color: 'gray',
                        z: 1
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
            }
        }
    })
})