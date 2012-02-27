### Constant Force Behaviour ###

class ConstantForce extends Behaviour

	constructor: (@force = new Vector()) ->

		super

	apply: (p, dt,index) ->

		#super p, dt, index

		p.acc.add @force