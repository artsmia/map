xhr = (url, f) ->
  x = new XMLHttpRequest; x.open('get', url); x.send()
  x.onreadystatechange = -> f(x) if x.readyState == 4

Map =
  init: (url='galleries.json') ->
    xhr url, (x) ->
      Markers.all = JSON.parse(x.responseText)
      Map.mark()

  mark: ->
    if gallery = window.location.hash.match(/(\d+)/) || window.location.search.match(/G(\d+)/)
      Markers.clear()
      Markers.add(gallery[1]).scrollIntoViewIfNeeded()
    else
      Markers.add(mark, true) for mark in Object.keys(Markers.all)

  svgify: (url_prefix="") ->
    swap_floor = (floor, x) -> document.getElementById(floor)?.innerHTML = x.responseText; Map.init()
    url_prefix = url_prefix + "svgs/"
    xhr "#{url_prefix}3.svg", (x) -> swap_floor(3, x)
    xhr "#{url_prefix}2.svg", (x) -> swap_floor(2, x)
    xhr "#{url_prefix}1.svg", (x) -> swap_floor(1, x)

  # Climb the dom until we find a `g > text`, that's probably the gallery id
  touched: (e) ->
    t = e.target
    if t.parentElement.nodeName == 'g'
      until t.nodeName == 'text' || t.parentElement.nodeName != 'g'
        t = t.parentElement.querySelector('text') || t.parentElement
    else
      t = null

    if id = t?.textContent.replace(/\s*/g, '').match(/(\d+)/)?[1]
      Map.clickCallback(id)

Markers =
  build: (x, y, stroked=false) ->
    m = document.createElement('span')
    m.classList.add('marker')
    m.classList.add('stroked') if stroked
    m.style.left = "#{x}px"
    m.style.top = "#{y}px"
    m

  add: (id, stroked=false) ->
    id = "#{id}"
    [x, y] = Markers.all[id]
    document.getElementById(id[0])?.appendChild @build(x, y, stroked)

  clear: -> d.parentNode.removeChild(d) while d = document.querySelector('.marker')

Map.init()
Map.svgify()
window.addEventListener "hashchange", Map.mark, false

Map.clickCallback = -> window.location.hash = "#{id}"

$map = document.querySelector('#map') || document
$map.addEventListener 'click', Map.touched
$map.addEventListener 'touchend', Map.touched
