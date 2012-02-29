/* Demo
*/
var Demo,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Demo = (function() {

  Demo.COLOURS = ['DC0048', 'F14646', '4AE6A9', '7CFF3F', '4EC9D9', 'E4272E'];

  function Demo() {
    this.mousemove = __bind(this.mousemove, this);
    this.resize = __bind(this.resize, this);    this.physics = new Physics();
    this.mouse = new Particle();
    this.mouse.fixed = true;
    this.height = window.innerHeight;
    this.width = window.innerWidth;
    this.renderer = new WebGLRenderer();
    this.renderer.mouse = this.mouse;
    if (!this.renderer.gl) {
      alert('WebGL not detected');
      throw 'WebGL not detected';
    }
    this.renderTime = 0;
  }

  Demo.prototype.setup = function() {
    /* Override and add paticles / springs here
    */
  };

  /* Initialise the demo (override).
  */

  Demo.prototype.init = function(container) {
    var particle, _i, _len, _ref;
    this.setup();
    _ref = this.physics.particles;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      particle = _ref[_i];
      if (particle.colour == null) particle.colour = Random.item(Demo.COLOURS);
    }
    window.addEventListener('mousemove', this.mousemove, false);
    window.addEventListener('resize', this.resize, false);
    container.appendChild(this.renderer.domElement);
    this.renderer.init(this.physics);
    return this.resize();
  };

  /* Handler for window resize event.
  */

  Demo.prototype.resize = function(event) {
    this.width = window.innerWidth;
    this.height = window.innerHeight;
    return this.renderer.setSize(this.width, this.height);
  };

  /* Handler for window mousemove event.
  */

  Demo.prototype.mousemove = function(event) {
    return this.mouse.pos.set(event.clientX, event.clientY);
  };

  /* Update loop.
  */

  Demo.prototype.step = function() {
    this.physics.step();
    return this.renderer.render(this.physics);
  };

  /* Clean up after yourself.
  */

  Demo.prototype.destroy = function() {
    window.removeEventListener('mousemove', this.mousemove);
    window.removeEventListener('resize', this.resize);
    container.removeChild(this.renderer.domElement);
    this.renderer.destroy();
    this.physics.destroy();
    this.renderer = null;
    this.physics = null;
    return this.mouse = null;
  };

  return Demo;

})();
