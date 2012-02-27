var ClothDemo,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

ClothDemo = (function(_super) {

  __extends(ClothDemo, _super);

  function ClothDemo() {
    ClothDemo.__super__.constructor.apply(this, arguments);
  }

  ClothDemo.prototype.setup = function() {
    var cell, cols, p, rows, s, size, stiffness, sx, sy, x, y;
    ClothDemo.__super__.setup.apply(this, arguments);
    this.renderer.renderParticles = false;
    this.physics.integrator = new Verlet();
    this.physics.timestep = 1.0 / 200;
    this.mouse.setMass(10);
    this.gravity = new ConstantForce(new Vector(0.0, 80.0));
    this.physics.behaviours.push(this.gravity);
    stiffness = 0.5;
    size = 8;
    rows = 30;
    cols = 55;
    cell = [];
    sx = this.width * 0.5 - cols * size * 0.5;
    sy = this.height * 0.5 - rows * size * 0.5;
    for (x = 0; 0 <= cols ? x <= cols : x >= cols; 0 <= cols ? x++ : x--) {
      cell[x] = [];
      for (y = 0; 0 <= rows ? y <= rows : y >= rows; 0 <= rows ? y++ : y--) {
        p = new Particle(0.1);
        p.fixed = y === 0;
        p.moveTo(new Vector(sx + x * size, sy + y * size));
        if (x > 0) {
          s = new Spring(p, cell[x - 1][y], size, stiffness);
          this.physics.springs.push(s);
        }
        if (y > 0) {
          s = new Spring(p, cell[x][y - 1], size, stiffness);
          this.physics.springs.push(s);
        }
        this.physics.particles.push(p);
        cell[x][y] = p;
      }
    }
    p = cell[Math.floor(cols / 2)][Math.floor(rows / 2)];
    s = new Spring(this.mouse, p, 10, 1.0);
    this.physics.springs.push(s);
    cell[0][0].fixed = true;
    return cell[cols - 1][0].fixed = true;
  };

  ClothDemo.prototype.step = function() {
    ClothDemo.__super__.step.apply(this, arguments);
    return this.gravity.force.x = 50 * Math.sin(new Date().getTime() * 0.0005);
  };

  return ClothDemo;

})(Demo);
