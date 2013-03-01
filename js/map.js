Marker = {
  dx: 11, dy: 20,

  move: function(x, y) {
    $marker.style.left = x - this.dx;
    $marker.style.top  = y - this.dy;
    this.updateState(x, y);
  },

  updateState: function(x, y) {
    history.pushState(null, null, '?x=' + x + '&y=' + y)
  },

  init: function() {
    m = window.location.search.match(/x=(\d+)&y=(\d+)/);
    if(m) {
      var x = m[1], y = m[2];
      this.move(x, y);
    }
  }
}

document.addEventListener("DOMContentLoaded", function() {
  $marker = document.getElementById('marker');
  $floorplan = document.getElementById('floorplan');
  $lines = document.getElementById('lines');
  $floorplan.addEventListener('mousedown', function(e) {
    e.preventDefault();
    console.log(e);
    Marker.move(e.pageX, e.pageY)
  });

  Marker.init()
  window.addEventListener("popstate", function(e) { Marker.init() })
})
