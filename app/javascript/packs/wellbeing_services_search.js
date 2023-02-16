const search_input_group = document.querySelector('.search.input-group'),
      search_input = search_input_group.querySelector('#search-input'),
      type_input = search_input_group.querySelector('#search-filter'),
      postcode_input =search_input_group.querySelector('#postcode-input'),
      radius_input = search_input_group.querySelector('#radius-input'),
      search_btn = search_input_group.querySelector('#search-btn'),
      url = new URL(location.href),
      search = function() {
        if (search_input.value) {
            url.searchParams.set('query', search_input.value)
        } else if (url.searchParams.has('query')) {
            url.searchParams.delete('query')
        }
        if(postcode_input.value){
            url.searchParams.set('postcode', postcode_input.value)
        }else if(url.searchParams.has('postcode')){
            url.searchParams.delete('postcode')
        }
        if(radius_input.value){
            url.searchParams.set('radius', radius_input.value)
        }else if(url.searchParams.has('radius')){
            url.searchParams.delete('radius')
        }
        if(type_input!=null){
            if (type_input.value == 'all') {
                if(url.searchParams.has('type')){
                    url.searchParams.delete('type')
                }
            } else {
                url.searchParams.set('type', type_input.value)
            }
        }
        if (url.searchParams.has('page')) url.searchParams.delete('page')
        if (url.searchParams.has('limit')) url.searchParams.delete('limit')

        location.href = url.href
      }

search_btn.addEventListener('click', search)
search_input.addEventListener('keyup', e => { if (e.key === 'Enter') search() })
postcode_input.addEventListener('keyup', e => { if (e.key === 'Enter') search() })
radius_input.addEventListener('keyup', e => { if (e.key === 'Enter') search() })

if (url.searchParams.has('query')) search_input.value = url.searchParams.get('query')
if (url.searchParams.has('type')) type_input.value = url.searchParams.get('type')
if (url.searchParams.has('postcode')) postcode_input.value = url.searchParams.get('postcode')
if (url.searchParams.has('radius')) radius_input.value = url.searchParams.get('radius')