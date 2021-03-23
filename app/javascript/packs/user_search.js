const user_search = document.querySelector('#user-search'),
      search_input = user_search.closest('div').querySelector('input')
      search = function() {
          const search_params = new URLSearchParams(window.location.search)
          search_params.set('query', search_input.value)

          history.pushState(null, null, `?${search_params.toString()}`)
          location.reload()
      }


user_search.addEventListener('click', search)
search_input.addEventListener('keyup', e => { if (e.key === 'Enter') search() })