const dropdown_items = document.querySelectorAll('.dropdown-item')
const chips = document.querySelectorAll('.chip')

const hideChip = (chip, name) => {
    chip.style.display = 'none'
    const parameter_field = document.getElementById(name)
    parameter_field.value = parameter_field.value.replace(clean_chip(chip.innerText), '')
 }

const showChip = (chip, name) => {
    chip.style.display = 'block'
    const parameter_field = document.getElementById(name)
    if (!(parameter_field.value.includes(chip.innerText))) {
        parameter_field.value += chip.innerText
    }
}

const clean_chip = (text) => {
    return text.trim()
}

const sanitizeName = (name) => {
    return name.replace(/[\s,\/, ']+/g, '-').toLowerCase();
}

dropdown_items.forEach(dropdown_item => {
    const filter_name = sanitizeName(dropdown_item.parentElement.className)
    const name = sanitizeName(filter_name + '-' + dropdown_item.innerHTML);
    dropdown_item.addEventListener('click', () => showChip(document.querySelector(`.dropdown-${name}`), filter_name));
})

chips.forEach(chip => {
    const filter_name = sanitizeName(chip.id)
    chip.addEventListener('click', () => hideChip(chip, filter_name))
})
