let count = 0
const interval = setInterval(() => {
    if (count < 10) {
        confetti()
        count++
    } else {
        clearInterval(interval)
    }
}, 1000)
