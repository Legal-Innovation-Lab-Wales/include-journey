const search_input_group = document.querySelector('.search.input-group'),
      search_input = search_input_group.querySelector('#search-input'),
      tag_input = search_input_group.querySelector('#search-filter'),
      assigned_input = search_input_group.querySelector('#search-assigned')
      search_btn = search_input_group.querySelector('#search-btn'),
      url = new URL(location.href),
      search = function() {
        if (search_input.value) {
            url.searchParams.set('query', search_input.value)
        } else if (url.searchParams.has('query')) {
            url.searchParams.delete('query')
        }
        if(assigned_input.checked){
            url.searchParams.set('assigned',assigned_input.value)
        }else{
            url.searchParams.set('assigned', false)
        }
        if(tag_input!=null){
            if (tag_input.value == 'all') {
                if(url.searchParams.has('tag')){
                    url.searchParams.delete('tag')
                }
            } else {
                url.searchParams.set('tag', tag_input.value)
            }
        }
        if (url.searchParams.has('page')) url.searchParams.delete('page')
        if (url.searchParams.has('limit')) url.searchParams.delete('limit')

        location.href = url.href
      }

search_btn.addEventListener('click', search)
search_input.addEventListener('keyup', e => { if (e.key === 'Enter') search() })

if (url.searchParams.has('query')) search_input.value = url.searchParams.get('query')
if (url.searchParams.has('tag')) tag_input.value = url.searchParams.get('tag')
if (url.searchParams.get('assigned')=='true') assigned_input.value = url.searchParams.get('assigned')
else if(url.searchParams.get('assigned')=='false') assigned_input.checked = false