# Get all the tspans in the SVG that look like a gallery
# getClientRects tells us where they are in the SVG
# JSONify and echo
walk_floor = (floor, memo) ->
  page = require('webpage').create()

  page.open "http://artsmia.github.io/map/svgs/#{floor}.svg", (status) ->
    page.onConsoleMessage = (m) -> console.log m

    g = page.evaluate ->
      galleries = {}
      tspans = document.querySelectorAll('text')
      for t in tspans
        text = t.textContent.replace(/\s*/g, '')
        if text.match(/^\d{3}a?$/)
          rect = t.getClientRects()[0]
          [x, y] = [rect.left+rect.width/2-3, rect.top+rect.height/2-2]
          marker = [x, y]
          galleries[text] = marker

      return galleries

    memo[room] = xy for room,xy of g

    page.close()
    if floor > 2
      console.log JSON.stringify(memo)
      phantom.exit()
    else
      walk_floor(floor+1, memo)

snapshots = (floor, memo) ->
  page = require('webpage').create()
  page.open "http://artsmia.github.io/map/svgs/#{floor}.svg", (status) ->
    g = page.evaluate ->
      rects = {}
      tspans = document.querySelectorAll('text')
      for t in tspans
        text = t.textContent.replace(/\s*/g, '')
        if text.match(/^\d{3}a?$/)
          rects[text] = t.getBoundingClientRect()

      return rects

    # memo[room] = rect for room,rect of g
    for room,rect of g
      pad = 100
      expandedRect = {
        left: rect['left']-pad,
        right: rect['right']+pad,
        top: rect['top']-pad,
        bottom: rect['bottom']+pad,
        height: rect['height']+pad*2,
        width: rect['width']+pad*2,
      } 
      page.clipRect = expandedRect
      page.render('galleries/'+room+'.png')

    page.close()
    if floor > 2
      # console.log(JSON.stringify(memo))
      phantom.exit()
    else
      snapshots(floor+1, memo)

system = require('system')
args = system.args

if args.length == 1
  console.log('snap: snap png thumbnails of all the galleries')
  console.log('walk: find all the galleries coordinates and log them')
  console.log('you need to choose one!')
  phantom.exit()
else if args[0] == 'snap'
  snapshots(1, {})
else
  walk_floor(1, {})


