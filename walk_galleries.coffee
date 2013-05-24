# Get all the tspans in the SVG that look like a gallery
# getClientRects tells us where they are in the SVG
# JSONify and echo
walk_floor = (floor, memo) ->
  page = require('webpage').create()

  page.open "http://mia-map/svgs/#{floor}.svg", (status) ->
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

walk_floor(1, {})
