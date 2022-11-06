const buttons = document.querySelectorAll('.navbar .btn')
const report = document.getElementById("report")
const dialogue = document.getElementById("dialogue")

buttons.forEach(btn => {
    const label = btn.querySelector('.nav-label')
    btn.addEventListener('mouseenter', () => label.classList.add('show'))
    btn.addEventListener('mouseleave', () => label.classList.remove('show'))
})

report.addEventListener('mouseup', () => dialogue.style.display= 'block')