const tags = document.querySelector('#tags-notes .tags'),
      add_new_btn = tags.querySelector('.card-footer button'),
      new_tag = tags.querySelector('.card-body .new.tag')

add_new_btn.addEventListener('click', () => new_tag.classList.remove('d-none'))
