### Physics Engine ###

class Physics

	constructor: (@integrator = new Euler()) ->

		# Fixed timestep.
		@timestep = 1.0 / 60

		# Friction within the system.
		@viscosity = 0.005

		# Global behaviours.
		@behaviours = []

		# Time in seconds.
		@_time = 0.0

		# Last step duration.
		@_step = 0.0

		# Current time.
		@_clock = null

		# Time buffer.
		@_buffer = 0.0

		# Max iterations per step.
		@_maxSteps = 4

		# Particles in system.
		@particles = []

		# Springs in system.
		@springs = []

	### Performs a numerical integration step. ###
	integrate: (dt) ->

		# Drag is inversely proportional to viscosity.
		drag = 1.0 - @viscosity

		# Update particles / apply behaviours.

		for particle, index in @particles

			for behaviour in @behaviours

				behaviour.apply particle, dt, index
			
			particle.update dt, index

		# Integrate motion.

		@integrator.integrate @particles, dt, drag

		# Compute all springs.
		
		for spring in @springs

			spring.apply()
	
	### Steps the system. ###
	step: ->

		# Initialise the clock on first step.
		@_clock ?= new Date().getTime()

		# Compute delta time since last step.
		time = new Date().getTime()
		delta = time - @_clock

		# No sufficient change.
		return if delta <= 0.0

		# Convert time to seconds.
		delta *= 0.001

		# Update the clock.
		@_clock = time

		# Increment time buffer.
		@_buffer += delta

		# Integrate until the buffer is empty or until the
		# maximum amount of iterations per step is reached.

		i = 0

		while @_buffer >= @timestep and ++i < @_maxSteps

			# Integrate motion by fixed timestep.
			@integrate @timestep

			# Reduce buffer by one timestep.
			@_buffer -= @timestep

			# Increment running time.
			@_time += @timestep

		# Store step time for debugging.
		@_step = new Date().getTime() - time

	### Clean up after yourself. ###
	destroy: ->

		@integrator = null
		@particles = null
		@springs = null

