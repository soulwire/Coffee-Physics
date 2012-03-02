class ClothDemo extends Demo

	setup: (full = yes) ->

		super

		# Only render springs.
		@renderer.renderParticles = false

		@physics.integrator = new Verlet()
		@physics.timestep = 1.0 / 200
		@mouse.setMass 10

		# Add gravity to the simulation.
		@gravity = new ConstantForce new Vector 0.0, 80.0
		@physics.behaviours.push @gravity

		stiffness = 0.5
		size = if full then 8 else 10
		rows = if full then 30 else 25
		cols = if full then 55 else 40
		cell = []

		sx = @width * 0.5 - cols * size * 0.5
		sy = @height * 0.5 - rows * size * 0.5

		for x in [0..cols]

			cell[x] = []

			for y in [0..rows]

				p = new Particle(0.1)

				p.fixed = (y is 0)

				# Always set initial position using moveTo for Verlet
				p.moveTo new Vector (sx + x * size), (sy + y * size)

				if x > 0
					s = new Spring p, cell[x-1][y], size, stiffness
					@physics.springs.push s

				if y > 0
					s = new Spring p, cell[x][y - 1], size, stiffness
					@physics.springs.push s

				@physics.particles.push p
				cell[x][y] = p

		p = cell[Math.floor cols / 2][Math.floor rows / 2]
		s = new Spring @mouse, p, 10, 1.0
		@physics.springs.push s

		cell[0][0].fixed = true
		cell[cols - 1][0].fixed = true

	step: ->

		super

		@gravity.force.x = 50 * Math.sin new Date().getTime() * 0.0005
