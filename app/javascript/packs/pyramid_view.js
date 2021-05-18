const pyramid_views = document.querySelectorAll('.pyramid-view')

pyramid_views.forEach(pyramid_view => {
    const pyramid_view_switch = pyramid_view.querySelector('.pyramid-view-switch'),
          pyramid_view_switch_text = pyramid_view_switch.querySelector('span')

    pyramid_view_switch.addEventListener('click', () => {
        pyramid_view.classList.toggle('flip')
        pyramid_view_switch_text.innerText = `View ${pyramid_view.classList.contains('flip') ? 'Chart': 'Pyramid'}`
    })
})