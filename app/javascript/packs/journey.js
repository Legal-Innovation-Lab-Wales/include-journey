import Tick from '@pqina/flip'

const counters = document.querySelectorAll('.counter')

counters.forEach(counter => {
    const tick = counter.querySelector('div'),
          count = tick.dataset.count

    Tick.DOM.create(tick, {
        value: 0,
        view: {
            children: [
                {
                    root: 'div',
                    layout: 'horizontal center',
                    repeat: true,
                    transform: `arrive(9, .001) -> round -> pad(${'0'.repeat(count.length)}) -> split -> delay(rtl, 100, 150)`,
                    children: [
                        {
                            view: 'flip'
                        }
                    ]
                }
            ]
        },
        didInit: tick => setTimeout(() => { tick.value = parseInt(count) }, 100)
    })
})

const progress_bars = document.querySelectorAll('.progress-bar')

progress_bars.forEach(progress_bar => {
    setTimeout(() => {
        progress_bar.style.width = `${progress_bar.dataset.width}%`

        const achievement = progress_bar.closest('.achievement'),
              medals = achievement.querySelectorAll('.medal')

        medals.forEach(medal => {
            if (medal.dataset.achieved === 'true') medal.classList.add('achieved')
        })
    }, 500)
})