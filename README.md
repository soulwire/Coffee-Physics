## Coffee Physics

A lightweight physics engine, written in [CoffeeScript](http://coffeescript.org/). Why? Why not!?

Early demos can be found here: [http://soulwire.github.com/Coffee-Physics/](http://soulwire.github.com/Coffee-Physics/)

#### A Quick Example

The CoffeePhysics API is designed to be very simple. Consider the following example:

	// Create a physics instance
	var physics = new Physics();

	// Design some behaviours for particles
	var attraction = new Attraction( new Vector( 200, 200 ) );

	// Allow particle collisions to make things interesting
	var collision = new Collision();

	for ( var i = 0; i < 1000; i++ ) {

		// Create a particle
		var particle = new Particle();

		// Make it collidable
		collision.pool.push( particle );

		// Apply behaviours
		particle.behaviours.push( attraction, collision );

		// Add to the simulation
		physics.particles.push( particle );
	}

	function update() {

		// Step the simulation
		physics.step();

		// Render particles
		for ( var i = 0, n = physics.particles.length; i < n; i++ ) {

			var particle = physics.particles[i];
			ctx.beginPath();
			ctx.arc( particle.x, particle.y, particle.mass * 10, 0, Math.PI * 2 );
			ctx.fill();
		}
		
		requestAnimationFrame( update );
	}

	// Kick it off
	update();