### Demo ###
class Demo

	#@COLOURS = ['00aeff', '0fa954', '54396e', 'e61d5f']
	@COLOURS = ['DC0048', 'F14646', '4AE6A9', '7CFF3F', '4EC9D9', 'E4272E']

	constructor: ->

		@physics = new Physics()
		@mouse = new Particle()
		@mouse.fixed = true
		@height = window.innerHeight
		@width = window.innerWidth

		# Use canvas renderer by default.
		#@renderer = new CanvasRenderer()
		@renderer = new WebGLRenderer()
		@renderer.mouse = @mouse

		@renderTime = 0;

	setup: ->

		### Override and add paticles / springs here ###

	### Initialise the demo (override). ###
	init: (container) ->

		console.log @, 'init'

		# Build the scene.
		do @setup

		# Give the particles random colours.
		for particle in @physics.particles
			particle.colour ?= Random.item Demo.COLOURS

		# Add event handlers.
		window.addEventListener 'mousemove', @mousemove, false
		window.addEventListener 'resize', @resize, false

		# Add to render output to the DOM.
		container.appendChild @renderer.domElement

		# Prepare the renderer.
		@renderer.init @physics

		# Resize for the sake of the renderer.
		do @resize

	### Handler for window resize event. ###
	resize: (event) =>

		@width = window.innerWidth
		@height = window.innerHeight
		@renderer.setSize @width, @height

	### Handler for window mousemove event. ###
	mousemove: (event) =>

		@mouse.pos.set event.clientX, event.clientY

	### Update loop. ###
	step: ->

		# Step physics.
		do @physics.step

		# Render.
		@renderer.render @physics

	### Clean up after yourself. ###
	destroy: ->

		console.log @, 'destroy'

		# Remove event handlers.
		window.removeEventListener 'mousemove', @mousemove
		window.removeEventListener 'resize', @resize

		# Remove the render output from the DOM.
		container.removeChild @renderer.domElement

		do @renderer.destroy
		do @physics.destroy

		@renderer = null
		@physics = null
		@mouse = null