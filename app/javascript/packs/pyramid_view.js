const pyramid_view_switch = document.querySelector('#pyramid-view-switch'),
      pyramid_view = document.querySelector('#pyramid-view')

pyramid_view_switch.addEventListener('change', () => pyramid_view.classList.toggle('flip'))