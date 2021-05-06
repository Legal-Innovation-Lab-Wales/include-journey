const checkboxes = document.querySelectorAll('input[type="checkbox"]'),
      select_all_btn = document.querySelector('button#select-all'),
      select_none_btn = document.querySelector('button#select-none'),
      toggle = checkbox => {
          const parent = checkbox.closest('div'),
                label = parent.querySelector('label'),
                icon = parent.querySelector('i')

          label.classList.toggle('selected')
          icon.classList.toggle('fa-check-circle')
          icon.classList.toggle('fa-times-circle')
      },
      toggle_all = select_all => {
          checkboxes.forEach(checkbox => {
              const parent = checkbox.closest('div'),
                    label = parent.querySelector('label'),
                    icon = parent.querySelector('i')

              if (select_all) {
                  label.classList.add('selected')
                  icon.classList.add('fa-check-circle')
                  icon.classList.remove('fa-times-circle')
                  checkbox.value = 1
                  checkbox.checked = true
              } else {
                  label.classList.remove('selected')
                  icon.classList.remove('fa-check-circle')
                  icon.classList.add('fa-times-circle')
                  checkbox.value = 0
                  checkbox.checked = false
              }
          })
      }

checkboxes.forEach(checkbox => checkbox.addEventListener('change', () => toggle(checkbox)))
select_all_btn.addEventListener('click', () => toggle_all(true))
select_none_btn.addEventListener('click', () => toggle_all(false))
