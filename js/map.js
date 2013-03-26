//@ sourceMappingURL=map.map
// Generated by CoffeeScript 1.6.1
var Map, Markers, xhr;

xhr = function(url, f) {
  var x;
  x = new XMLHttpRequest;
  x.open('get', url);
  x.send();
  return x.onreadystatechange = function() {
    if (x.readyState === 4) {
      return f(x);
    }
  };
};

Map = {
  init: function(url) {
    if (url == null) {
      url = 'galleries.json';
    }
    return xhr(url, function(x) {
      Markers.all = JSON.parse(x.responseText);
      return Map.mark();
    });
  },
  mark: function() {
    var gallery, mark, _i, _len, _ref, _results;
    if (gallery = window.location.hash.match(/(\d+)/)) {
      Markers.clear();
      return Markers.add(gallery[1]).scrollIntoViewIfNeeded();
    } else {
      _ref = Object.keys(Markers.all);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        mark = _ref[_i];
        _results.push(Markers.add(mark, true));
      }
      return _results;
    }
  },
  svgify: function() {
    var swap_floor;
    swap_floor = function(floor, x) {
      document.getElementById(floor).innerHTML = x.responseText;
      return Map.init();
    };
    xhr("svgs/3.svg", function(x) {
      return swap_floor(3, x);
    });
    xhr("svgs/2.svg", function(x) {
      return swap_floor(2, x);
    });
    return xhr("svgs/1.svg", function(x) {
      return swap_floor(1, x);
    });
  }
};

Markers = {
  build: function(x, y, stroked) {
    var m;
    if (stroked == null) {
      stroked = false;
    }
    m = document.createElement('span');
    m.classList.add('marker');
    if (stroked) {
      m.classList.add('stroked');
    }
    m.style.left = x;
    m.style.top = y;
    return m;
  },
  add: function(id, stroked) {
    var x, y, _ref, _ref1;
    if (stroked == null) {
      stroked = false;
    }
    _ref = Markers.all[id], x = _ref[0], y = _ref[1];
    return (_ref1 = document.getElementById(id[0])) != null ? _ref1.appendChild(this.build(x, y, stroked)) : void 0;
  },
  clear: function() {
    var d, _results;
    _results = [];
    while (d = document.querySelector('.marker')) {
      _results.push(d.parentNode.removeChild(d));
    }
    return _results;
  }
};

Map.init();

Map.svgify();

window.addEventListener("hashchange", Map.mark, false);

document.addEventListener('click', function(e) {
  var id, t, _ref;
  t = e.target;
  if (t.parentElement.nodeName === 'g') {
    while (!(t.nodeName === 'text' || t.parentElement.nodeName !== 'g')) {
      t = t.parentElement.querySelector('text') || t.parentElement;
    }
  } else {
    t = null;
  }
  if (id = t != null ? (_ref = t.textContent.replace(/\s*/g, '').match(/(\d+)/)) != null ? _ref[1] : void 0 : void 0) {
    console.log(t, t.textContent, id);
    return window.location.hash = "" + id;
  }
});
