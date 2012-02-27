/* Physics Engine
*/
var Physics;

Physics = (function() {

  function Physics(integrator) {
    this.integrator = integrator != null ? integrator : new Euler();
    this.timestep = 1.0 / 120;
    this.viscosity = 0.005;
    this.behaviours = [];
    this._time = 0.0;
    this._step = 0.0;
    this._clock = null;
    this._buffer = 0.0;
    this._maxSteps = 10;
    this.particles = [];
    this.springs = [];
  }

  /* Performs a numerical integration step.
  */

  Physics.prototype.integrate = function(dt) {
    var behaviour, drag, index, particle, spring, _i, _j, _len, _len2, _len3, _ref, _ref2, _ref3, _results;
    drag = 1.0 - this.viscosity;
    _ref = this.particles;
    for (index = 0, _len = _ref.length; index < _len; index++) {
      particle = _ref[index];
      _ref2 = this.behaviours;
      for (_i = 0, _len2 = _ref2.length; _i < _len2; _i++) {
        behaviour = _ref2[_i];
        behaviour.apply(particle, dt, index);
      }
      particle.update(dt, index);
    }
    this.integrator.integrate(this.particles, dt, drag);
    _ref3 = this.springs;
    _results = [];
    for (_j = 0, _len3 = _ref3.length; _j < _len3; _j++) {
      spring = _ref3[_j];
      _results.push(spring.apply());
    }
    return _results;
  };

  /* Steps the system.
  */

  Physics.prototype.step = function() {
    var delta, i, time;
    if (this._clock == null) this._clock = new Date().getTime();
    time = new Date().getTime();
    delta = time - this._clock;
    if (delta <= 0.0) return;
    delta *= 0.001;
    this._clock = time;
    this._buffer += delta;
    i = 0;
    while (this._buffer >= this.timestep && ++i < this._maxSteps) {
      this.integrate(this.timestep);
      this._buffer -= this.timestep;
      this._time += this.timestep;
    }
    return this._step = new Date().getTime() - time;
  };

  /* Clean up after yourself.
  */

  Physics.prototype.destroy = function() {
    this.integrator = null;
    this.particles = null;
    return this.springs = null;
  };

  return Physics;

})();
