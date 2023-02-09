const data_select = document.getElementById('data'),
      shared_with_select = document.getElementById('member'),
      authored_by_select = document.getElementById('author'),
      member_parent = document.getElementById("member-parent");


const isAdmin = member_parent.dataset.admin

if ((data_select.value) == "Wellbeing Assessments") { 
    shared_with_select.style.display = 'none';  
} else {
    if(isAdmin === "false" && data_select.value !== "Contact Logs"){
        member_parent.style.display = "none";
    }
    authored_by_select.style.display = 'none';
}

data_select.addEventListener('change', function() {
    if (data_select.value == 'Wellbeing Assessments'){
        if (shared_with_select != null) {shared_with_select.style.display = 'none';}
        authored_by_select.style.display = 'block';
    } else {
        if(isAdmin === "false"){
            if(data_select.value !== "Contact Logs"){
                member_parent.style.display = "none";
            } else {
                member_parent.style.display = "block";
            }
        }else {
            if((data_select.value) == "Contact Logs"){
                shared_with_select.previousElementSibling.innerHTML = "Created By";
            }else {
                shared_with_select.previousElementSibling.innerHTML = "Shared With";
            }
        }
        if (shared_with_select != null) {shared_with_select.style.display = 'block';}
        authored_by_select.style.display = 'none';
    }
})
