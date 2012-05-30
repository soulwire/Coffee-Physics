### DOM Renderer ###
###

	Updating styles:

	Nodes

###
class DOMRenderer extends Renderer

	constructor: ->

		super

		@useGPU = yes
		
		@domElement = document.createElement 'div'
		@canvas = document.createElement 'canvas'
		@ctx = @canvas.getContext '2d'

		@canvas.style.position = 'absolute'
		@canvas.style.left = 0
		@canvas.style.top = 0

		@domElement.style.pointerEvents = 'none'
		@domElement.appendChild @canvas

	init: (physics) ->

		super physics

		for p in physics.particles

			el = document.createElement 'span'
			st = el.style

			st.backgroundColor = p.colour
			st.borderRadius = p.radius
			st.marginLeft = -p.radius
			st.marginTop = -p.radius
			st.position = 'absolute'
			st.display = 'block'
			st.opacity = 0.85
			st.height = p.radius * 2
			st.width = p.radius * 2

			@domElement.appendChild el
			p.domElement = el

	render: (physics) ->

		super physics

		time = new Date().getTime()

		if @renderParticles

			for p in physics.particles

				if @useGPU

					p.domElement.style.WebkitTransform = """
						translate3d(#{p.pos.x|0}px,#{p.pos.y|0}px,0px)
						"""

				else

					p.domElement.style.left = p.pos.x
					p.domElement.style.top = p.pos.y

		if @renderSprings

			@canvas.width = @canvas.width
			
			@ctx.strokeStyle = 'rgba(255,255,255,0.1)'
			@ctx.beginPath()

			for s in physics.springs
				@ctx.moveTo(s.p1.pos.x, s.p1.pos.y)
				@ctx.lineTo(s.p2.pos.x, s.p2.pos.y)
			
			@ctx.stroke()

		@renderTime = new Date().getTime() - time

	setSize: (@width, @height) =>

        super @width, @height

        @canvas.width = @width
        @canvas.height = @height