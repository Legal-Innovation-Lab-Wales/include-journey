const chart_wrapper = document.getElementById('chart-carousel-inner');
const metric_select = document.getElementById('metric-select');
const resources = document.getElementById('resources');
const data = JSON.parse(resources.dataset.resource);
const type = resources.dataset.type;
const chart_select = resources.dataset.chart;
var date_from = resources.dataset.datefrom;
var date_to = resources.dataset.dateto;
const wellbeing_labels = JSON.parse(resources.dataset.labels);
const wellbeing_colours = JSON.parse(resources.dataset.colours);
const diary_labels = [
    String.fromCodePoint("0x"+'1F973'),
    String.fromCodePoint("0x"+'1F60A'),
    String.fromCodePoint("0x"+'1F614'),
    String.fromCodePoint("0x"+'1F620'),
    String.fromCodePoint("0x"+'1F4A9'),
    String.fromCodePoint("0x"+'1F610')
];
const diary_colours= [
    '#5DAD3AE6', // 🥳
    '#82b438E6', // ☺️
    '#F0A656E6', // 😔
    '#E04444E6', // 😡
    '#eb7945E6', // 💩
    '#DFC54CE6' // 😐
];
const wellbeing_metric_colours = [
    '#FF3333E6',
    '#FF9933E6',
    '#FFFF33E6',
    '#99FF33E6',
    '#33FF33E6',
    '#33FF99E6',
    '#33FFFFE6',
    '#3399FFE6',
    '#3333FFE6',
    '#9933FFE6',
    '#FF33FFE6',
    '#FF3399E6'
];

[...chart_wrapper.children].forEach(child => child.remove());
[...metric_select.children].forEach(child => child.remove());

if(chart_select=="Line Chart"){
    create_line_charts()
}else{
    if(type=="Wellbeing Assessments"){        
        create_wellbeing();
    } else if (type=="Contact Logs"){
        create_contact_log()
    }else{
        create_diary();
    }
}

function create_contact_log(){
    const labelsValue = {}
    const colors = []
    data.forEach(item =>{
        if (labelsValue[item.contact_type_name]) {
            labelsValue[item.contact_type_name] = labelsValue[item.contact_type_name] + 1
        } else {
            labelsValue[item.contact_type_name] = 1
            colors.push(item.contact_type_color)
        }
    })

    wellbeing_labels.forEach((label, i) => {
        if(!labelsValue[label]){
            labelsValue[label] = 0
            colors.push(wellbeing_colours[i])
        }
    })

    const contact_data = {
        labels: Object.keys(labelsValue),
        datasets: [{
            label: '',
            data: Object.values(labelsValue),
            backgroundColor: colors
        }]
    }
    canvas = create_canvas(0, 'Contact Log', true)
    switch(chart_select){
        case 'Pie Chart':
            create_pie_chart(canvas, contact_data)
            break;
        case 'Bar Chart':
            create_bar_chart(canvas, contact_data)
            break;
    }
}
function create_wellbeing(){
    scores = new Array();
    data.forEach((assessment) => {
        scores.push(assessment.Scores)
    })
    metrics = new Array();
    scores[0].forEach((metric) => {
        metrics.push(Object.keys(metric)[0]);
    })

    metrics.forEach((metric, index) => {
        values = [0,0,0,0,0,0,0,0,0,0];
        for(var i=0; i<scores.length;i++){
            value = scores[i][index][metric];
            values[value-1]++;
        }   
        wellbeing_data = {
            labels: wellbeing_labels,
            datasets: [{
                label: '',
                data: values,
                backgroundColor: wellbeing_colours
            }],
            options: {
                animateRotate: true,
            }
        }
        canvas = create_canvas(index, metric, index==0)
        switch(chart_select){
            case 'Pie Chart':
                create_pie_chart(canvas, wellbeing_data)
                break;
            case 'Bar Chart':
                create_bar_chart(canvas, wellbeing_data)
                break;
        }

    })

    metric_select.addEventListener('change', e => {
        toggle_active(chart_wrapper, e, '.carousel-item')
    })
}

function create_diary(){
    //  🥳    ☺️     😔    😡    💩     😐  //
    //1F973 1F60A 1F614 1F620 1F4A9 1F610//
    values = [0,0,0,0,0,0];
    for(var i =0; i<data.length; i++){
        unicode = data[i].Feeling.codePointAt(0).toString(16).toUpperCase();
        switch(unicode){
            case '1F973':
                values[0]++;
                break;
            case '1F60A':
                values[1]++;
                break;
            case '1F614':
                values[2]++;
                break;
            case '1F620':
                values[3]++;
                break;
            case '1F4A9':
                values[4]++;
                break;
            case '1F610':
                values[5]++;
                break;
        }
    }
    diary_data = {
        labels: diary_labels,
        datasets: [{
            label: '',
            data: values,
            backgroundColor: diary_colours
        }]
    }
    canvas = create_canvas(0, 'Diary Feelings', true)
    switch(chart_select){
        case 'Pie Chart':
            create_pie_chart(canvas, diary_data)
            break;
        case 'Bar Chart':
            create_bar_chart(canvas, diary_data)
            break;
    }
}

function create_line_charts(){

    if(date_from==""){ date_from = data[0].Date }
    if(date_to==""){ date_to = data[data.length-1].Date}
    start_date = new Date(convert_date(date_from));
    end_date = new Date(convert_date(date_to));
    number_of_weeks = Math.ceil(Math.floor((end_date - start_date) / (1000*60*60*24))/7)

    xLabels = new Array(number_of_weeks);
    week_groups = new Array(number_of_weeks)
    for(var i=0; i<week_groups.length; i++){
        week_groups[i] = new Array();
        week_date = new Date(start_date),
        week_date.setDate(week_date.getDate() + (7*i))
        xLabels[i] = week_date.toLocaleDateString();
    }
    if(type=="Wellbeing Assessments"){    
        scores = new Array();
        data.forEach((assessment) => {
            scores.push(assessment.Scores)
        })
        metrics = new Array();
        scores[0].forEach((metric) => {
            metrics.push(Object.keys(metric)[0]);
        })
        line_datasets = new Array(metrics.length);
        for(var i=0; i<line_datasets.length;i++){
            line_datasets[i] ={
                label: metrics[i],
                data: new Array(number_of_weeks).fill(0),
                fill:false,
                borderColor: wellbeing_metric_colours[i],
                tension: 0
            };
        }
        options = {
            scales: {
                yAxes: [{
                    ticks: {
                        min: 1,
                        max: 10,
                        stepSize: 1,
                        padding: 15,
                    }
                }]
            }
        }
        chart_label = "Average Wellbeing Assessment Scores"
    } else if (type == "Contact Logs") {
       
        line_datasets = new Array(wellbeing_labels.length);
        for (var i = 0; i < line_datasets.length; i++) {
            line_datasets[i] = {
                label: wellbeing_labels[i],
                data: new Array(number_of_weeks).fill(0),
                fill: false,
                borderColor: wellbeing_colours[i],
                tension: 0
            }
        }
        options = {
            scales: {
                yAxes: [{
                    ticks: {
                        min: 0,
                    }
                }]
            }
        }
        chart_label = "Contact Logs"
    }else{
        line_datasets = new Array(diary_labels.length);
        for(var i=0;i<line_datasets.length;i++){
            line_datasets[i] = {
                label: diary_labels[i],
                data: new Array(number_of_weeks).fill(0),
                fill:false,
                borderColor:diary_colours[i],
                tension: 0
            }
        }
        options = {
            scales: {
                yAxes: [{
                    ticks: {
                        min: 0,
                    }
                }]
            }
        }
        chart_label = "Diary Feelings"
    }
    data.forEach((entry) => {
        entry_date = new Date(convert_date(entry.Date));
        week_number = Math.ceil(Math.floor((entry_date - start_date) / (1000*60*60*24))/7)
        if(week_number==0){ week_number = 1;}
        entry.week_index = week_number-1;
        week_groups[week_number-1].push(entry)
        if(type === "Diary Entries"){     
            unicode = entry.Feeling.codePointAt(0).toString(16).toUpperCase();
            switch(unicode){
                case '1F973':
                    line_datasets[0].data[entry.week_index]++;
                    break;
                case '1F60A':
                    line_datasets[1].data[entry.week_index]++;
                    break;
                case '1F614':
                    line_datasets[2].data[entry.week_index]++;
                    break;
                case '1F620':
                    line_datasets[3].data[entry.week_index]++;
                    break;
                case '1F4A9':
                    line_datasets[4].data[entry.week_index]++;
                    break;
                case '1F610':
                    line_datasets[5].data[entry.week_index]++;
                    break;
            }
        }else if(type === "Contact Logs"){   

            line_datasets.forEach(line_data=>{
                if(line_data.label === entry.contact_type_name){
                    line_data.data[entry.week_index]++;
                }
            })
        
         }
    })
    if(type =="Wellbeing Assessments"){
        for(var i=0;i<number_of_weeks;i++){
            if(week_groups[i].length>0){
                metrics.forEach((metric, index) => {
                    week_groups[i].forEach((entry) => {
                        line_datasets[index].data[i] += entry.Scores[index][metric]
                    })
                    line_datasets[index].data[i] /= week_groups[i].length
                })
            }
        }
    }
    line_data = {
        labels: xLabels,
        datasets: line_datasets
    };
    canvas = create_canvas(0, chart_label, true);
    create_line_chart(canvas, line_data, options);

}

function create_canvas(index, label, active){
    const carousel_item = document.createElement('div')
    carousel_item.classList.add('carousel-item')
    if(active){ carousel_item.classList.add('active') }
    const canvas = document.createElement('canvas')
    carousel_item.append(canvas)
    chart_wrapper.append(carousel_item)

    const option = document.createElement('option')
    option.setAttribute('value', index)
    option.innerHTML = label
    metric_select.append(option)

    return canvas
}

function create_pie_chart(canvas, data){
    new Chart(canvas.getContext('2d'), {
        type: 'pie',
        data: data
    })
}

function create_bar_chart(canvas, data){
    new Chart(canvas.getContext('2d'), {
        type: 'bar',
        data: data,
        options: {
            scales: {
                yAxes: [{
                    ticks:{
                        beginAtZero: true
                    }
                }]
            }
        }
    })
}

function create_line_chart(canvas, data, options){
    new Chart(canvas.getContext('2d'), {
        type: 'line',
        data: data,
        options: options
    })
}

function toggle_active(parent, event, css_selector){
    parent.querySelector('.active').classList.remove('active')
    parent.querySelectorAll(css_selector)[event.target.value].classList.add('active')
}

function convert_date(date){
    seperated_date = date.split(" ");
    reversed_date = seperated_date[0].split("/").reverse().join("/");
    for(var i =1; i<seperated_date.length;i++){
        reversed_date += " " + seperated_date[i];
    }
    return reversed_date; 
}