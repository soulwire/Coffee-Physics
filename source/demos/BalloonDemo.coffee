### BalloonDemo ###
class BalloonDemo extends Demo

	setup: ->

		super

		@physics.integrator = new ImprovedEuler()
		attraction = new Attraction @mouse.pos

		for i in [0..400]

			p = new Particle (Random 0.25, 4.0)
			p.setRadius p.mass * 8

			p.behaviours.push new Wander 0.2
			p.behaviours.push attraction
			
			p.moveTo new Vector (Random @width), (Random @height)

			s = new Spring @mouse, p, (Random 30, 300), 1.0

			@physics.particles.push p
			@physics.springs.push s

