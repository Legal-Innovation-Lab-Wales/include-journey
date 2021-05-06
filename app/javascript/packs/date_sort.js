const date_sort = document.querySelector('.date-sort-select select'),
      url = new URL(location.href)

date_sort.addEventListener('change', () => {
    url.searchParams.set('sort', date_sort.value)
    location.href = url.href
})

if (url.searchParams.has('sort')) {
    const sort = url.searchParams.get('sort'),
          option = date_sort.querySelector(`option[value="${sort}"]`)

    if (option) date_sort.value = sort
}
