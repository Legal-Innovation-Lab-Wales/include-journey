fetch(`${location}/wba_history`, {
    headers: {
        'Content-Type': 'application/json'
    }
})
    .then(data => data.json())
    .then(json => {
        const schemeCategory10 = [
            '#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd',
            '#8c564b', '#e377c2', '#7f7f7f', '#bcbd22', '#17becf'
        ]

        json.datasets.forEach((dataset, index) => {
            dataset.borderColor = schemeCategory10[index]
            dataset.backgroundColor = `${schemeCategory10[index]}80`
            dataset.lineTension = 0
            dataset.hidden = index > 0
        })

        const history_chart = document.querySelector('#wellbeing-history-chart')
        const chart = new Chart(history_chart.getContext('2d'), {
            type: 'line',
            data: json,
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            min: 1,
                            max: 10,
                            stepSize: 1
                        }
                    }]
                }
            }
        })
    })