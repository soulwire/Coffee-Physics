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

		# Set up particle DOM elements
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

		# Set up mouse DOM element
		el = document.createElement 'span'
		st = el.style
		mr = 20

		st.backgroundColor = '#ffffff'
		st.borderRadius = mr
		st.marginLeft = -mr
		st.marginTop = -mr
		st.position = 'absolute'
		st.display = 'block'
		st.opacity = 0.1
		st.height = mr * 2
		st.width = mr * 2

		@domElement.appendChild el
		@mouse.domElement = el

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

		if @renderMouse

			if @useGPU

				@mouse.domElement.style.WebkitTransform = """
					translate3d(#{@mouse.pos.x|0}px,#{@mouse.pos.y|0}px,0px)
					"""
			else

				@mouse.domElement.style.left = @mouse.pos.x
				@mouse.domElement.style.top = @mouse.pos.y

		@renderTime = new Date().getTime() - time

	setSize: (@width, @height) =>

        super @width, @height

        @canvas.width = @width
        @canvas.height = @height

    destroy: ->

    	while @domElement.hasChildNodes()
    		@domElement.removeChild @domElement.lastChild
