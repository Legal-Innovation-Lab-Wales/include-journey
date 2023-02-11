const allCheckboxSelector = document.getElementById("all-users"),
      allCheckBoxes = document.querySelectorAll(".user_ids");

      allCheckboxSelector.addEventListener("change", function(e){
        const isChecked = e.target.checked
        allCheckBoxes.forEach(function(checkBox){
            checkBox.checked = isChecked
        })
    })