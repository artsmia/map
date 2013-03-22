xhr = (url, f) ->
  x = new XMLHttpRequest; x.open('get', url); x.send()
  x.onreadystatechange = -> f(x) if x.readyState == 4

Map =
  init: (url='galleries.json') ->
    xhr url, (x) ->
      Markers.all = JSON.parse(x.responseText)
      Map.mark()

  mark: ->
    if gallery = window.location.hash.match(/(\d+)/)
      Markers.clear()
      Markers.add(gallery[1]).scrollIntoViewIfNeeded()
    else
      Markers.add(mark, true) for mark in Object.keys(Markers.all)

  svgify: ->
    swap_floor = (floor, x) -> document.getElementById(floor).innerHTML = x.responseText; Map.init()
    xhr "/svgs/3.svg", (x) -> swap_floor(3, x)
    xhr "/svgs/2.svg", (x) -> swap_floor(2, x)
    xhr "/svgs/1.svg", (x) -> swap_floor(1, x)

Markers =
  build: (x, y, stroked=false) ->
    m = document.createElement('span')
    m.classList.add('marker')
    m.classList.add('stroked') if stroked
    m.style.left = x
    m.style.top = y
    m

  add: (id, stroked=false) ->
    [x, y] = Markers.all[id]
    floor = document.getElementById(id[0])
    floor.appendChild @build(x, y, stroked)

  clear: -> d.parentNode.removeChild(d) while d = document.querySelector('.marker')

Map.init()
Map.svgify()
window.addEventListener "hashchange", Map.mark, false
