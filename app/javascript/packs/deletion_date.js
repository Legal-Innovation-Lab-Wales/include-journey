const deletion_date = document.querySelector('.deletion-date'),
      timer = deletion_date.querySelector('.timer'),
      unix_ts = parseInt(deletion_date.getAttribute('data-deletion-date')),
      count_down_date = new Date(unix_ts).getTime(),
      get_unit = (value, unit) => {
        return `${value > 0 ? `${value}${unit} ` : ''}`
      }

const interval = setInterval(() => {
    const now = new Date().getTime(),
          difference = count_down_date - now,
          days = Math.floor(difference / (1000 * 60 * 60 * 24)),
          hours = Math.floor((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
          minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60))

    let seconds = Math.floor((difference % (1000 * 60)) / 1000)
    seconds = seconds >= 0 ? seconds : 0

    timer.innerHTML = `${get_unit(days, 'd')}${get_unit(hours, 'h')}${get_unit(minutes, 'm')}${seconds}s`

    if (difference <= 0) {
        clearInterval(interval)
        location.reload()
    }
}, 1000)
