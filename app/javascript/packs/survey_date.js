const start_date = document.getElementById("survey_start_date");
const end_date = document.getElementById("survey_end_date");


start_date.addEventListener("change", function(e){
    end_date.value = "";
    end_date.setAttribute("min", e.target.value);
})