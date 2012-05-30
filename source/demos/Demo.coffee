### Demo ###
class Demo

	@COLOURS = ['DC0048', 'F14646', '4AE6A9', '7CFF3F', '4EC9D9', 'E4272E']

	constructor: ->

		@physics = new Physics()
		@mouse = new Particle()
		@mouse.fixed = true
		@height = window.innerHeight
		@width = window.innerWidth

		# Use canvas renderer by default.
		#@renderer = new WebGLRenderer()
		@renderer = new DOMRenderer()
		@renderer.mouse = @mouse

		# if not @renderer.gl
		# 	alert 'WebGL not detected'
		# 	throw 'WebGL not detected'

		@renderTime = 0;
		@counter = 0

	setup: (full = yes) ->

		### Override and add paticles / springs here ###

	### Initialise the demo (override). ###
	init: (container) ->

		## console.log @, 'init'

		# Build the scene.
		@setup @renderer.gl?

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
		window.removeEventListener 'mousemove', @mousemove
		window.removeEventListener 'resize', @resize

		# Remove the render output from the DOM.
		try container.removeChild @renderer.domElement
		catch error

		do @renderer.destroy
		do @physics.destroy

		@renderer = null
		@physics = null
		@mouse = null