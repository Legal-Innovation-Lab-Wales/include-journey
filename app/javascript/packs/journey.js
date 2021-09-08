import Tick from '@pqina/flip'

const counters = document.querySelectorAll('.counter.session')

counters.forEach(counter => {
    const tick = counter.querySelector('[data-count]'),
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

const medals = document.querySelectorAll('.counter .medal')

medals.forEach(medal => {
    setTimeout(() => {
        const tick = medal.querySelector('[data-count]'),
            count = parseInt(tick.dataset.count)

        if (count > 0) {
            let i = 0;

            const timer = Tick.helper.interval(() => {
                i++;
                tick.innerHTML = `${i}`;

                if (i === count) timer.stop()
            }, 1000)
        }
    }, 1000)
})