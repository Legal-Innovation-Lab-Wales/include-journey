const search_input_group = document.querySelector('.search.input-group'),
      search_input = search_input_group.querySelector('#search-input'),
      uploads_activity_type = search_input_group.querySelector('#uploads-activity-type'),
      search_btn = search_input_group.querySelector('#search-btn'),
      url = new URL(location.href),
      search = () => {
          if (search_input.value) {
              url.searchParams.set('query', search_input.value)
          } else if (url.searchParams.has('query')) {
              url.searchParams.delete('query')
          }

          if (uploads_activity_type.value === 'all') {
              if (url.searchParams.has('activity_type')) url.searchParams.delete('activity_type')
          } else {
              url.searchParams.set('activity_type', uploads_activity_type.value)
          }

          if (url.searchParams.has('page')) url.searchParams.delete('page')
          if (url.searchParams.has('limit')) url.searchParams.delete('limit')

          location.href = url.href
      }

search_btn.addEventListener('click', search)
search_input.addEventListener('keyup', e => { if (e.key === 'Enter') search() })

if (url.searchParams.has('query')) search_input.value = url.searchParams.get('query')
if (url.searchParams.has('activity_type')) uploads_activity_type.value = url.searchParams.get('activity_type')

