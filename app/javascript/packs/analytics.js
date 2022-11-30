const data_select = document.getElementById('data'),
      shared_with_select = document.getElementById('member'),
      authored_by_select = document.getElementById('author');

if ((data_select.value) == "Wellbeing Assessments") { 
    shared_with_select.style.display = 'none';  
} else {
    authored_by_select.style.display = 'none';
}

data_select.addEventListener('change', function() {
    if (data_select.value == 'Wellbeing Assessments'){
        if (shared_with_select != null) {shared_with_select.style.display = 'none';}
        authored_by_select.style.display = 'block';
    } else {
        if (shared_with_select != null) {shared_with_select.style.display = 'block';}
        authored_by_select.style.display = 'none';
    }
})
