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
      Markers.add(gallery[1])?.scrollIntoViewIfNeeded?()
    else
      Markers.add(mark, true) for mark in Object.keys(Markers.all)

  svgify: (floors=[1,2,3], url_prefix="", f) ->
    swap_floor = (floor, x) -> document.getElementById(floor)?.innerHTML = x.responseText
    url_prefix = url_prefix + "svgs/"
    for i in floors
      if !Map.svg_enabled
        document.querySelector("#map img").setAttribute('src',  "#{url_prefix}#{i}.svg")
        setTimeout(f, 200) if f?
      else
        xhr "#{url_prefix}#{i}.svg", (x) => swap_floor(i, x); f?()

  svg_enabled: -> Modernizr && Modernizr.svg

  # Climb the dom until we find a `g > text`, that's probably the gallery id
  get_gallery_id_from_event: (e) ->
    t = e.target
    if t.parentElement?.nodeName == 'g'
      until t.nodeName == 'text' || t.parentElement.nodeName != 'g'
        t = t.parentElement.querySelector('text') || t.parentElement
    else
      t = null

    t?.textContent.replace(/\s*/g, '').match(/(\d+)/)?[1]

  touched: (e) -> Map.clickCallback(id) if id = Map.get_gallery_id_from_event(e)
  hover: (e) -> Map.hoverCallback(id) if id = Map.get_gallery_id_from_event(e)
  unhover: (e) -> Map.unhoverCallback()

Markers =
  build: (x, y, stroked=false) ->
    m = document.createElement('span')
    if m.classList?
      m.classList.add('marker')
      m.classList.add('stroked') if stroked
    else
      m.setAttribute('class', 'marker') # IE<9 doesn't support classList
    m.style.left = "#{x}px"
    m.style.top = "#{y}px"
    m

  add: (id, stroked=false) ->
    id = "#{id}"
    if id && Markers.all[id]?
      [x, y] = Markers.all[id]
      document.getElementById(id[0])?.appendChild @build(x, y, stroked)

  clear: -> d.parentNode.removeChild(d) while d = document.querySelector('.marker')

# Map.init()
# Map.svgify()
# window.addEventListener "hashchange", Map.mark, false

# Map.clickCallback = -> window.location.hash = "#{id}"

$map = document.querySelector('#map') || document
$map.addEventListener 'click', Map.touched
$map.addEventListener 'touchend', Map.touched
$map.addEventListener('mouseover', Map.hover)
$map.addEventListener('mouseout', Map.unhover)
