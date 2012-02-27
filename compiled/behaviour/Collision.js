/* Collision Behaviour
*/
var Collision,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

Collision = (function(_super) {

  __extends(Collision, _super);

  function Collision(useMass, callback) {
    this.useMass = useMass != null ? useMass : true;
    this.callback = callback != null ? callback : null;
    this.pool = [];
    this._delta = new Vector();
    Collision.__super__.constructor.apply(this, arguments);
  }

  Collision.prototype.apply = function(p, dt, index) {
    var dist, distSq, i, mt, o, overlap, r1, r2, radii, _ref, _results;
    _results = [];
    for (i = index, _ref = this.pool.length - 1; index <= _ref ? i <= _ref : i >= _ref; index <= _ref ? i++ : i--) {
      o = this.pool[i];
      if (o !== p) {
        (this._delta.copy(o.pos)).sub(p.pos);
        distSq = this._delta.magSq();
        radii = p.radius + o.radius;
        if (distSq <= radii * radii) {
          dist = Math.sqrt(distSq);
          overlap = (p.radius + o.radius) - dist;
          overlap += 0.5;
          mt = p.mass + o.mass;
          r1 = this.useMass ? o.mass / mt : 0.5;
          r2 = this.useMass ? p.mass / mt : 0.5;
          p.pos.add(this._delta.clone().norm().scale(overlap * -r1));
          o.pos.add(this._delta.norm().scale(overlap * r2));
          _results.push(typeof this.callback === "function" ? this.callback(p, o, overlap) : void 0);
        } else {
          _results.push(void 0);
        }
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  return Collision;

})(Behaviour);
