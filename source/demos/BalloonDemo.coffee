### BalloonDemo ###
class BalloonDemo extends Demo

	setup: (full = yes) ->

		super

		@physics.integrator = new ImprovedEuler()
		attraction = new Attraction @mouse.pos

		max = if full then 400 else 200

		for i in [0..max]

			p = new Particle (Random 0.25, 4.0)
			p.setRadius p.mass * 8

			p.behaviours.push new Wander 0.2
			p.behaviours.push attraction
			
			p.moveTo new Vector (Random @width), (Random @height)

			s = new Spring @mouse, p, (Random 30, 300), 1.0

			@physics.particles.push p
			@physics.springs.push s

