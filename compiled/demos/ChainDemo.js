var ChainDemo,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

ChainDemo = (function(_super) {

  __extends(ChainDemo, _super);

  function ChainDemo() {
    ChainDemo.__super__.constructor.apply(this, arguments);
  }

  ChainDemo.prototype.setup = function() {
    var center, edge, gap, i, max, min, op, p, s, wander;
    ChainDemo.__super__.setup.apply(this, arguments);
    this.stiffness = 1.0;
    this.spacing = 2.0;
    this.physics.integrator = new Verlet();
    this.physics.viscosity = 0.0001;
    this.mouse.setMass(1000);
    gap = 50.0;
    min = new Vector(-gap, -gap);
    max = new Vector(this.width + gap, this.height + gap);
    edge = new EdgeBounce(min, max);
    center = new Vector(this.width * 0.5, this.height * 0.5);
    wander = new Wander(0.05, 100.0, 80.0);
    for (i = 0; i <= 2000; i++) {
      p = new Particle(6.0);
      p.colour = '#FFFFFF';
      p.moveTo(center);
      p.setRadius(1.0);
      p.behaviours.push(wander);
      p.behaviours.push(edge);
      this.physics.particles.push(p);
      if (typeof op !== "undefined" && op !== null) {
        s = new Spring(op, p, this.spacing, this.stiffness);
      } else {
        s = new Spring(this.mouse, p, this.spacing, this.stiffness);
      }
      this.physics.springs.push(s);
      op = p;
    }
    return this.physics.springs.push(new Spring(this.mouse, p, this.spacing, this.stiffness));
  };

  return ChainDemo;

})(Demo);
