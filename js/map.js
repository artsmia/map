Marker = {
  dx: 11, dy: 20,

  move: function(x, y) {
    this.x = $marker.style.left = x - this.dx;
    this.y = $marker.style.top  = y - this.dy;
    this.updateState(x, y);
    this.updateForm();
  },

  updateState: function(x, y) {
    history.pushState(null, null, '?x=' + x + '&y=' + y)
  },

  updateForm: function() {
    $id.value = "";
    $id.hidden = false;
  },

  save: function() {
    $id.hidden = '1'
    id = $id.value;
    console.log(id, this.x, this.y);
    localStorage.setItem(id, JSON.stringify(this.point()));
    this.mark(this.x, this.y);
  },

  point: function() { return [this.x, this.y]; },

  init: function() {
    m = window.location.search.match(/x=(\d+)&y=(\d+)/);
    if(m) {
      var x = m[1], y = m[2];
      this.move(x, y);
    }
    this.populate();
  },

  populate: function() {
    ids = Object.getOwnPropertyNames(localStorage);
    ids.forEach(function(id) {
      var info = JSON.parse(localStorage[id]),
          x = info[0],
          y = info[1];
      Marker.mark(x, y);
    });
  },

  mark: function(x, y) {
    m = document.createElement('span');
    m.classList.add('marker');
    m.style.left = x;
    m.style.top = y;
    $floorplan.appendChild(m);
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

  $form = document.querySelector('form')
  $id = document.querySelector('input')
  $form.addEventListener('submit', function(e) {
    e.preventDefault();
    Marker.save();
  })

  Marker.init()
  window.addEventListener("popstate", function(e) { Marker.init() })
})
