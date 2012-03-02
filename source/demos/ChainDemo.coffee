class ChainDemo extends Demo

	setup: (full = yes) ->

		super

		@stiffness = 1.0
		@spacing = 2.0

		@physics.integrator = new Verlet()
		@physics.viscosity = 0.0001
		@mouse.setMass 1000

		gap = 50.0
		min = new Vector -gap, -gap
		max = new Vector @width + gap, @height + gap

		edge = new EdgeBounce min, max

		center = new Vector @width * 0.5, @height * 0.5

		#@renderer.renderParticles = no

		wander = new Wander 0.05, 100.0, 80.0

		max = if full then 2000 else 600

		for i in [0..max]

			p = new Particle 6.0
			p.colour = '#FFFFFF'
			p.moveTo center
			p.setRadius 1.0

			p.behaviours.push wander
			p.behaviours.push edge

			@physics.particles.push p

			if op? then s = new Spring op, p, @spacing, @stiffness
			else s = new Spring @mouse, p, @spacing, @stiffness

			@physics.springs.push s

			op = p

		@physics.springs.push new Spring @mouse, p, @spacing, @stiffness