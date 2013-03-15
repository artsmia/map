# Get all the tspans in the SVG that look like a gallery
# getClientRects tells us where they are in the SVG
# JSONify and echo
walk_floor = (floor) ->
  page = require('webpage').create()

  page.open "http://mia-map/svgs/#{floor}.svg", (status) ->
    page.onConsoleMessage = (m) -> console.log m

    g = page.evaluate ->
      galleries = {}
      tspans = document.querySelectorAll('tspan')
      for t in tspans
        text = t.textContent.replace(/\s*/g, '')
        if text.match(/^\d{3}$/)
          rect = t.getClientRects()[0]
          # ↓ It shoudl probably look like this ↓
          # [x, y] = [rect.left+rect.width/2, rect.top+rect.height/2]
          # but the .marker css is 24px square and maybe not positioned quite right
          [x, y] = [rect.left-rect.width/2+13, rect.top-rect.height/2-5]
          marker = [x, y]
          galleries[text] = marker

      return galleries

    console.log JSON.stringify(g)

    page.close()
    if floor > 2 then phantom.exit() else walk_floor(floor+1)

walk_floor(1)
