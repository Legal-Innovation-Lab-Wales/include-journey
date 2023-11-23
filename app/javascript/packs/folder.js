const buttons = document.querySelectorAll(".context-buttons");
const action_buttons = document.querySelectorAll(".context-button-actions");

const close_all_dropdowns = () => {
  const all_menus = document.querySelectorAll(".show");
  
  all_menus.forEach((menu) => {
    menu.classList.remove("show");
  });
};

const close_open_context_menu = (e)=>{
    const menu = document.querySelector(".show");
    if (menu && !menu.contains(e.target) && !e.target.classList.contains('context-button-actions')) {
        menu.classList.remove("show");
    }
}


document.addEventListener("click", close_open_context_menu);

action_buttons.forEach((button) => {
  const dropdownDiv = document.querySelector(
    `[data-dropdown-id=folderDropdownMenu-${button.id}]`
  );
  button.addEventListener("click", (e) => {
    close_all_dropdowns()
    e.preventDefault();
    dropdownDiv.style.left = `${e.clientX - 170}px`;
    dropdownDiv.classList.add("show");
  });
});


buttons.forEach((button) => {
  const dropdownDiv = document.querySelector(
    `[data-dropdown-id=folderDropdownMenu-${button.id}]`
  );

  button.addEventListener("contextmenu", (e) => {
    close_all_dropdowns()
    e.preventDefault();
    dropdownDiv.style.left = `${e.clientX - 170}px`;
    dropdownDiv.classList.add("show");
  });
});
