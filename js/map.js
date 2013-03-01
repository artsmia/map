document.addEventListener("DOMContentLoaded", function() {
  $marker = document.getElementById('markers');
  $floorplan = document.getElementById('floorplan');
  $lines = document.getElementById('lines');
  $floorplan.addEventListener('mousedown', function(e) {
    e.preventDefault();
    console.log(e);
    var dx = 11, dy = 20;
    $marker.style.top = e.pageY - dy;
    $marker.style.left = e.pageX - dx;
  });
})

