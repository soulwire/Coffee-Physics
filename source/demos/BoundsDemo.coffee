### BoundsDemo ###
class BoundsDemo extends Demo
	
	setup: ->

		super

		min = new Vector 0.0, 0.0
		max = new Vector @width, @height

		edge = new EdgeWrap min, max

		for i in [0..200]

			p = new Particle (Random 0.5, 4.0)
			p.setRadius p.mass * 5

			p.moveTo new Vector (Random @width), (Random @height)

			p.behaviours.push new Wander 0.2, 120, Random 1.0, 2.0
			p.behaviours.push edge

			@physics.particles.push p

		