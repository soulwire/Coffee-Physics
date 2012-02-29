### Behaviour ###

class Behaviour

	# Each behaviour has a unique id
	@GUID = 0

	constructor: ->

		@GUID = Behaviour.GUID++
		@interval = 1

		## console.log @, @GUID

	apply: (p, dt, index) ->

		# Store some data in each particle.
		(p['__behaviour' + @GUID] ?= {counter: 0}).counter++