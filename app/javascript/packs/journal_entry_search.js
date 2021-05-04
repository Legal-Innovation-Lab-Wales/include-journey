const search_input_group = document.querySelector('.search.input-group'),
      search_input = search_input_group.querySelector('#search-input'),
      viewed_input = search_input_group.querySelector('#viewed-input'),
      feeling_input = search_input_group.querySelector('#feeling-input'),
      search_btn = search_input_group.querySelector('#search-btn'),
      url = new URL(location.href),
      search = () => {
          if (search_input.value) url.searchParams.set('query', search_input.value)

          if (viewed_input.value === 'all') {
              if (url.searchParams.has('viewed')) url.searchParams.delete('viewed')
          } else {
              url.searchParams.set('viewed', viewed_input.value)
          }

          if (feeling_input.value === 'all') {
              if (url.searchParams.has('feeling')) url.searchParams.delete('feeling')
          } else {
              url.searchParams.set('feeling', feeling_input.value)
          }

          if (url.searchParams.has('page')) url.searchParams.delete('page')
          if (url.searchParams.has('limit')) url.searchParams.delete('limit')

          location.href = url.href
      }

search_btn.addEventListener('click', search)
search_input.addEventListener('keyup', e => { if (e.key === 'Enter') search() })
