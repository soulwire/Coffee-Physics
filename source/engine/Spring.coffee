### Spring ###

class Spring

	constructor: (@p1, @p2, @restLength = 100, @stiffness = 1.0) ->

		@_delta = new Vector()

	# F = -kx
	
	apply: ->

		(@_delta.copy @p2.pos).sub @p1.pos

		dist = @_delta.mag() + 0.000001
		force = (dist - @restLength) / (dist * (@p1.massInv + @p2.massInv)) * @stiffness

		if not @p1.fixed

			@p1.pos.add (@_delta.clone().scale force * @p1.massInv)

		if not @p2.fixed

			@p2.pos.add (@_delta.scale -force * @p2.massInv)