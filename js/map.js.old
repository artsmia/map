Marker = {
  dx: 11, dy: 20,

  _move: function(e) {
    this.move(e.pageX - this.target.offsetLeft, e.pageY - this.target.offsetTop);
  },

  move: function(clickpoint) {
    console.log(clickpoint.target);
    window.target = target;
    this.floor = this.target.id;

    this.x = $marker.style.left = x - this.dx;
    this.y = $marker.style.top  = y - this.dy;
    console.log(this.x, this.y);
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
    this.store(this.floor, id);
    this.mark(this.x, this.y);
  },

  store: function(floor_id, id) {
    var floor = localStorage[floor_id];
    if(floor == undefined) floor = '{}';
    floor = JSON.parse(floor);
    floor[id] = JSON.stringify(this.point());
    localStorage[floor_id] = JSON.stringify(floor);
  },

  point: function() { return [this.x, this.y]; },

  init: function() {
    m = window.location.search.match(/x=(\d+)&y=(\d+)/);
    if(m) {
      var x = m[1], y = m[2];
      this.mark(x, y); // TODO: how do I know which floor?
    }
    this.populate();
  },

  populate: function() {
    ids = Object.getOwnPropertyNames(localStorage);
    [1, 2, 3].forEach(function(floor) {
      target = document.getElementById(floor)
      ids.forEach(function(id) {
        var info = JSON.parse(localStorage[id]),
            x = info[0],
            y = info[1];
        Marker.mark(x, y, target);
      });
    })
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
    Marker.move(e.pageX, e.pageY, target)
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
