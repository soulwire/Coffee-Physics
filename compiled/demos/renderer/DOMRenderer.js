/* DOM Renderer
*/
/*

	Updating styles:

	Nodes
*/
var DOMRenderer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

DOMRenderer = (function(_super) {

  __extends(DOMRenderer, _super);

  function DOMRenderer() {
    this.setSize = __bind(this.setSize, this);    DOMRenderer.__super__.constructor.apply(this, arguments);
    this.useGPU = true;
    this.domElement = document.createElement('div');
    this.canvas = document.createElement('canvas');
    this.ctx = this.canvas.getContext('2d');
    this.canvas.style.position = 'absolute';
    this.canvas.style.left = 0;
    this.canvas.style.top = 0;
    this.domElement.style.pointerEvents = 'none';
    this.domElement.appendChild(this.canvas);
  }

  DOMRenderer.prototype.init = function(physics) {
    var el, p, st, _i, _len, _ref, _results;
    DOMRenderer.__super__.init.call(this, physics);
    _ref = physics.particles;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      p = _ref[_i];
      el = document.createElement('span');
      st = el.style;
      st.backgroundColor = p.colour;
      st.borderRadius = p.radius;
      st.marginLeft = -p.radius;
      st.marginTop = -p.radius;
      st.position = 'absolute';
      st.display = 'block';
      st.opacity = 0.85;
      st.height = p.radius * 2;
      st.width = p.radius * 2;
      this.domElement.appendChild(el);
      _results.push(p.domElement = el);
    }
    return _results;
  };

  DOMRenderer.prototype.render = function(physics) {
    var p, s, time, _i, _j, _len, _len2, _ref, _ref2;
    DOMRenderer.__super__.render.call(this, physics);
    time = new Date().getTime();
    if (this.renderParticles) {
      _ref = physics.particles;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        p = _ref[_i];
        if (this.useGPU) {
          p.domElement.style.WebkitTransform = "translate3d(" + (p.pos.x | 0) + "px," + (p.pos.y | 0) + "px,0px)";
        } else {
          p.domElement.style.left = p.pos.x;
          p.domElement.style.top = p.pos.y;
        }
      }
    }
    if (this.renderSprings) {
      this.canvas.width = this.canvas.width;
      this.ctx.strokeStyle = 'rgba(255,255,255,0.1)';
      this.ctx.beginPath();
      _ref2 = physics.springs;
      for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
        s = _ref2[_j];
        this.ctx.moveTo(s.p1.pos.x, s.p1.pos.y);
        this.ctx.lineTo(s.p2.pos.x, s.p2.pos.y);
      }
      this.ctx.stroke();
    }
    return this.renderTime = new Date().getTime() - time;
  };

  DOMRenderer.prototype.setSize = function(width, height) {
    this.width = width;
    this.height = height;
    DOMRenderer.__super__.setSize.call(this, this.width, this.height);
    this.canvas.width = this.width;
    return this.canvas.height = this.height;
  };

  return DOMRenderer;

})(Renderer);
