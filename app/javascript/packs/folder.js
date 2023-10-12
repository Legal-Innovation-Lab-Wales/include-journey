const buttons = document.querySelectorAll(".context-buttons");

const close_all_dropdowns = () => {
  const all_menus = document.querySelectorAll(".show");
  
  all_menus.forEach((menu) => {
    menu.classList.remove("show");
  });
};

const close_open_context_menu = (e)=>{
    const menu = document.querySelector(".show");
    if (menu && !menu.contains(e.target)) {
        menu.classList.remove("show");
    }
}


document.addEventListener("click", close_open_context_menu);

buttons.forEach((button) => {
  const dropdownDiv = document.querySelector(
    `[data-dropdown-id=folderDropdownMenu-${button.id}]`
  );
  button.addEventListener("click", (e) => {
    dropdownDiv.classList.remove("show");
  });

  button.addEventListener("contextmenu", (e) => {
    close_all_dropdowns()
    e.preventDefault();
    dropdownDiv.classList.add("show");
  });
});
