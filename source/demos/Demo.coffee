### Demo ###
class Demo

	@COLOURS = ['DC0048', 'F14646', '4AE6A9', '7CFF3F', '4EC9D9', 'E4272E']

	constructor: ->

		@physics = new Physics()
		@mouse = new Particle()
		@mouse.fixed = true
		@height = window.innerHeight
		@width = window.innerWidth

		@renderTime = 0
		@counter = 0

	setup: (full = yes) ->

		### Override and add paticles / springs here ###

	### Initialise the demo (override). ###
	init: (@container, @renderer = new WebGLRenderer()) ->

		# Build the scene.
		@setup renderer.gl?

		# Give the particles random colours.
		for particle in @physics.particles
			particle.colour ?= Random.item Demo.COLOURS

		# Add event handlers.
		document.addEventListener 'touchmove', @mousemove, false
		document.addEventListener 'mousemove', @mousemove, false
		document.addEventListener 'resize', @resize, false

		# Add to render output to the DOM.
		@container.appendChild @renderer.domElement

		# Prepare the renderer.
		@renderer.mouse = @mouse
		@renderer.init @physics

		# Resize for the sake of the renderer.
		do @resize

	### Handler for window resize event. ###
	resize: (event) =>

		@width = window.innerWidth
		@height = window.innerHeight
		@renderer.setSize @width, @height

	### Update loop. ###
	step: ->

		#console.profile 'physics'

		# Step physics.
		do @physics.step

		#console.profileEnd()

		#console.profile 'render'

		# Render.

		# Render every frame for WebGL, or every 3 frames for canvas.
		@renderer.render @physics if @renderer.gl? or ++@counter % 3 is 0

		#console.profileEnd()

	### Clean up after yourself. ###
	destroy: ->

		## console.log @, 'destroy'

		# Remove event handlers.
		document.removeEventListener 'touchmove', @mousemove, false
		document.removeEventListener 'mousemove', @mousemove, false
		document.removeEventListener 'resize', @resize, false

		# Remove the render output from the DOM.
		try container.removeChild @renderer.domElement
		catch error

		do @renderer.destroy
		do @physics.destroy

		@renderer = null
		@physics = null
		@mouse = null

	### Handler for window mousemove event. ###
	mousemove: (event) =>

		do event.preventDefault

		if event.touches and !!event.touches.length
			
			touch = event.touches[0]
			@mouse.pos.set touch.pageX, touch.pageY

		else

			@mouse.pos.set event.clientX, event.clientY
