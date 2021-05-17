const pyramid_view_switch = document.querySelector('#pyramid-view-switch'),
      pyramid_view_switch_text = pyramid_view_switch.querySelector('span'),
      pyramid_view = document.querySelector('#pyramid-view')

pyramid_view_switch.addEventListener('click', () => {
    pyramid_view.classList.toggle('flip')
    pyramid_view_switch_text.innerText = `View ${pyramid_view.classList.contains('flip') ? 'Chart': 'Pyramid'}`
})