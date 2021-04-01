const search_btn = document.querySelector('#search-btn'),
      search_input = document.querySelector('#search-input'),
      search = function() {
          const url = new URL(location.href)
          url.searchParams.set('query', search_input.value)
          if (url.searchParams.has('page')) url.searchParams.delete('page')
          if (url.searchParams.has('limit')) url.searchParams.delete('limit')

          location.href = url.href
      }

search_btn.addEventListener('click', search)
search_input.addEventListener('keyup', e => { if (e.key === 'Enter') search() })
