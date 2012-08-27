### Particle ###
class Particle

	@GUID = 0

	constructor: (@mass = 1.0) ->

		# Set a unique id.
		@id = 'p' + Particle.GUID++

		# Set initial mass.
		@setMass @mass

		# Set initial radius.
		@setRadius 1.0

		# Apply forces.
		@fixed = false

		# Behaviours to be applied.
		@behaviours = []

		# Current position.
		@pos = new Vector()

		# Current velocity.
		@vel = new Vector()

		# Current force.
		@acc = new Vector()

		# Previous state.
		@old =
			pos: new Vector()
			vel: new Vector()
			acc: new Vector()

	### Moves the particle to a given location vector. ###
	moveTo: (pos) ->

		@pos.copy pos
		@old.pos.copy pos

	### Sets the mass of the particle. ###
	setMass: (@mass = 1.0) ->

		# The inverse mass.
		@massInv = 1.0 / @mass

	### Sets the radius of the particle. ###
	setRadius: (@radius = 1.0) ->

		@radiusSq = @radius * @radius

	### Applies all behaviours to derive new force. ###
	update: (dt, index) ->

		# Apply all behaviours.

		if not @fixed
			
			for behaviour in @behaviours

				behaviour.apply @, dt, index