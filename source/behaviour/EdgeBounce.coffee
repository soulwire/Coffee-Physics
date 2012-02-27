### Edge Bounce Behaviour ###

class EdgeBounce extends Behaviour

	constructor: (@min = new Vector(), @max = new Vector()) ->

		super
	
	apply: (p, dt, index) ->

		#super p, dt, index

		if p.pos.x - p.radius < @min.x

			p.pos.x = @min.x + p.radius

		else if p.pos.x + p.radius > @max.x

			p.pos.x = @max.x - p.radius

		if p.pos.y - p.radius < @min.y

			p.pos.y = @min.y + p.radius

		else if p.pos.y + p.radius > @max.y

			p.pos.y = @max.y - p.radius

