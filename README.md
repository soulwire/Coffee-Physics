## Coffee Physics

A lightweight physics engine, written in [CoffeeScript](http://coffeescript.org/). Why? Why not!?

Early demos can be found here: [http://soulwire.github.com/Coffee-Physics/](http://soulwire.github.com/Coffee-Physics/)

#### A Quick Example

The CoffeePhysics API is designed to be very simple. Consider the following [example](http://jsfiddle.net/soulwire/Ra5Ve/):

	// Create a physics instance which uses the Verlet integration method
	var physics = new Physics();
	physics.integrator = new Verlet();

	// Design some behaviours for particles
	var avoidMouse = new Attraction();
	var pullToCenter = new Attraction();

	// Allow particle collisions to make things interesting
	var collision = new Collision();

	// Use Sketch.js to make life much easier
	var example = Sketch.create({ container: document.body });

	example.setup = function() {

	    for ( var i = 0; i < 200; i++ ) {

	        // Create a particle
	        var particle = new Particle( Math.random() );
	        var position = new Vector( random( this.width ), random( this.height ) );
	        particle.setRadius( particle.mass * 10 );
	        particle.moveTo( position );

	        // Make it collidable
	        collision.pool.push( particle );

	        // Apply behaviours
	        particle.behaviours.push( avoidMouse, pullToCenter, collision );

	        // Add to the simulation
	        physics.particles.push( particle );
	    }
	    
	    pullToCenter.target.x = this.width / 2;
	    pullToCenter.target.y = this.height / 2;
	    pullToCenter.strength = 120;
	    
	    avoidMouse.setRadius( 60 );
	    avoidMouse.strength = -1000;
	    
	    example.fillStyle = '#ff00ff';
	}

	example.draw = function() {

	    // Step the simulation
	    physics.step();

	    // Render particles
	    for ( var i = 0, n = physics.particles.length; i < n; i++ ) {

	        var particle = physics.particles[i];
	        example.beginPath();
	        example.arc( particle.pos.x, particle.pos.y, particle.radius, 0, Math.PI * 2 );
	        example.fill();
	    }
	}

	example.mousemove = function() {
	    avoidMouse.target.x = example.mouse.x;
	    avoidMouse.target.y = example.mouse.y;
	}