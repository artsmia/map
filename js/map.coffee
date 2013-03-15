Map =
  init: (url='galleries.json') ->
    x = new XMLHttpRequest; x.open('get', url); x.send()
    x.onreadystatechange = ->
      if x.readyState == 4
        Markers.all = JSON.parse(x.responseText)
        Map.mark()

  mark: ->
    if gallery = window.location.search.match(/g=(\d+)/)
      Markers.add(gallery[1])
    else
      Markers.add(mark) for mark in Object.keys(Markers.all)

Markers =
  build: (x, y) ->
    m = document.createElement('span')
    m.classList.add('marker')
    m.style.left = x
    m.style.top = y
    m

  add: (id) ->
    [x, y] = Markers.all[id]
    floor = document.getElementById(id[0])
    floor.appendChild @build(x, y)

Map.init()
