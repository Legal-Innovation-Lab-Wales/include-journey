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