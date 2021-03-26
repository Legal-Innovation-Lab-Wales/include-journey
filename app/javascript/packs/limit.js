const limit_select = document.querySelector('.limit-select'),
      select = limit_select.querySelector('select'),
      add_listener = () => {
          select.addEventListener('change', () => {
              const url = new URL(location.href)
              url.searchParams.set('limit', select.value)
              if (url.searchParams.has('page')) url.searchParams.delete('page')

              location.href = url.href
          })
      },
      search_params = new URLSearchParams(location.search)

if (search_params.has('limit')) {
    const option = limit_select.querySelector(`option[value="${search_params.get('limit')}"]`)
    if (option) option.setAttribute('selected', 'true')

    add_listener()
} else {
    add_listener()
}
