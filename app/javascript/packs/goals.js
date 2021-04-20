const short_term_add = document.querySelector('.short-term .add'),
      short_term_form = document.querySelector('.short-term form'),
      short_term_cancel = document.querySelector('.short-term .cancel'),
      long_term_add = document.querySelector('.long-term .add'),
      long_term_form = document.querySelector('.long-term form'),
      long_term_cancel = document.querySelector('.long-term .cancel'),
      toggle_form = (e, form, add) => {
          e.preventDefault()
          add.classList.toggle('hidden')
          form.classList.toggle('hidden')
      },
      goals = document.querySelectorAll('.list-group-item'),
      toggle_icon = (icon, mouseover) => {
          if (mouseover) {
              icon.classList.remove('far')
              icon.classList.remove('fa-square')
              icon.classList.add('fas')
              icon.classList.add('fa-check-square')
          } else {
              icon.classList.add('far')
              icon.classList.add('fa-square')
              icon.classList.remove('fas')
              icon.classList.remove('fa-check-square')
          }
      }
      toggle_check = goal => {
          if (!goal.classList.contains('achieved')) {
              const icon = goal.querySelector('i')
              goal.addEventListener('mouseover', () => toggle_icon(icon, true))
              goal.addEventListener('mouseleave', () => toggle_icon(icon, false))
          }
      }

short_term_add.addEventListener('click', e => toggle_form(e, short_term_form, short_term_add))
long_term_add.addEventListener('click', e => toggle_form(e, long_term_form, long_term_add))
short_term_cancel.addEventListener('click', e => toggle_form(e, short_term_form, short_term_add))
long_term_cancel.addEventListener('click', e => toggle_form(e, long_term_form, long_term_add))
goals.forEach(goal => { if (!goal.classList.contains('achieved')) toggle_check(goal) })
