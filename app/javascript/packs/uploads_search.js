const search_input_group = document.querySelector('.search.input-group'),
      search_input = search_input_group.querySelector('#search-input'),
      uploads_added_by = search_input_group.querySelector('#uploads-added-by'),
      uploads_type = search_input_group.querySelector('#uploads-type'),
      uploads_visible_to_user = search_input_group.querySelector('#uploads-visible-to-user'),
      search_btn = search_input_group.querySelector('#search-btn'),
      url = new URL(location.href),
      search = () => {
          if (search_input.value) {
              url.searchParams.set('query', search_input.value)
          } else if (url.searchParams.has('query')) {
              url.searchParams.delete('query')
          }

          if (uploads_added_by.value === 'all') {
              if (url.searchParams.has('added')) url.searchParams.delete('added')
          } else {
              url.searchParams.set('added', uploads_added_by.value)
          }

          if (uploads_type.value === 'all') {
              if (url.searchParams.has('type')) url.searchParams.delete('type')
          } else {
              url.searchParams.set('type', uploads_type.value)
          }

          if (uploads_visible_to_user.value === 'all') {
                if (url.searchParams.has('visible')) url.searchParams.delete('visible')
            } else {
                url.searchParams.set('visible', uploads_visible_to_user.value)
            }

          if (url.searchParams.has('page')) url.searchParams.delete('page')
          if (url.searchParams.has('limit')) url.searchParams.delete('limit')

          location.href = url.href
      }

search_btn.addEventListener('click', search)
search_input.addEventListener('keyup', e => { if (e.key === 'Enter') search() })

if (url.searchParams.has('query')) search_input.value = url.searchParams.get('query')
if (url.searchParams.has('added')) uploads_added_by.value = url.searchParams.get('added')
if (url.searchParams.has('type')) uploads_type.value = url.searchParams.get('type')
if (url.searchParams.has('visible')) uploads_visible_to_user.value = url.searchParams.get('visible')

