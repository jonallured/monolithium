const pad = (num) => (`0${num}`.slice(-2))

const formatTime = (time) => {
  const month = pad(time.getMonth() + 1)
  const day = pad(time.getDate())
  const year = time.getFullYear()

  const hourPart = time.getHours()
  const hour12 = (hourPart === 0 || hourPart === 12) ? 12 : ((hourPart + 12) % 12)
  const hour = pad(hour12)
  const ampm = hourPart < 12 ? "am" : "pm"

  const minute = pad(time.getMinutes())
  const second = pad(time.getSeconds())

  const text = `${month}/${day}/${year} ${hour}:${minute}:${second}${ampm}`
  return text
}

const intz = () => {
  const timeElements = document.querySelectorAll("time[data-intz='false']")

  for (const timeElement of timeElements) {
    const datetime = timeElement.getAttribute("datetime")
    const localTime = new Date(Date.parse(datetime))
    const localText = formatTime(localTime)
    timeElement.innerText = localText
    timeElement.setAttribute("data-intz", "true")
  }
}

export { intz }
