const search_btn = document.querySelector('#search-btn'),
      search_input = document.querySelector('#search-input'),
      search = function() {
          const search_params = new URLSearchParams(window.location.search)
          search_params.set('query', search_input.value)

          // if (search_params.has('page')) {
          //     search_params.delete('page')
          // }

          history.pushState(null, null, `?${search_params.toString()}`)
          location.reload()
      }

search_btn.addEventListener('click', search)
search_input.addEventListener('keyup', e => { if (e.key === 'Enter') search() })