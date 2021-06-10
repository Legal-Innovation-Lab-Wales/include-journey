const sort_columns = document.querySelectorAll('.sort-column'),
      url = new URL(location.href)

sort_columns.forEach(sort_column => {
    const current_icon = sort_column.querySelector('i:not(.hidden)'),
          column_value = sort_column.querySelector('span.text').dataset.value

    current_icon.addEventListener('click', () => {
        url.searchParams.set('sort', column_value)

        if (current_icon.classList.contains('fa-sort')) {
            url.searchParams.set('direction', 'desc')
        } else {
            // Flip the sort direction.
            url.searchParams.set('direction', `${current_icon.classList.contains('fa-caret-down') ? 'asc' : 'desc'}`)
        }
        location.href = url.href
    })
})
