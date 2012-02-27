/* Euler Integrator
*/
var Euler,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

Euler = (function(_super) {

  __extends(Euler, _super);

  function Euler() {
    Euler.__super__.constructor.apply(this, arguments);
  }

  Euler.prototype.integrate = function(particles, dt, drag) {
    var p, vel, _i, _len, _results;
    vel = new Vector();
    _results = [];
    for (_i = 0, _len = particles.length; _i < _len; _i++) {
      p = particles[_i];
      if (!(!p.fixed)) continue;
      p.old.pos.copy(p.pos);
      p.acc.scale(p.massInv);
      vel.copy(p.vel);
      p.vel.add(p.acc.scale(dt));
      p.pos.add(vel.scale(dt));
      if (drag) p.vel.scale(drag);
      _results.push(p.acc.clear());
    }
    return _results;
  };

  return Euler;

})(Integrator);
