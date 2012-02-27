### 2D Vector ###

class Vector
	
	### Adds two vectors and returns the product. ###
	@add: (v1, v2) ->
		new Vector v1.x + v2.x, v1.y + v2.y
	
	### Subtracts v2 from v1 and returns the product. ###
	@sub: (v1, v2) ->
		new Vector v1.x - v2.x, v1.y - v2.y

	### Projects one vector (v1) onto another (v2) ###
	@project: (v1, v2) ->
		v1.clone().scale ((v1.dot v2) / v1.magSq())

	### Creates a new Vector instance. ###
	constructor: (@x = 0.0, @y = 0.0) ->

	### Sets the components of this vector. ###
	set: (@x, @y) ->
		@
	
	### Add a vector to this one. ###
	add: (v) ->
		@x += v.x; @y += v.y; @
	
	### Subtracts a vector from this one. ###
	sub: (v) ->
		@x -= v.x; @y -= v.y; @

	### Scales this vector by a value. ###
	scale: (f) ->
		@x *= f; @y *= f; @

	### Computes the dot product between vectors. ###
	dot: (v) ->
		@x * v.x + @y * v.y

	### Computes the cross product between vectors. ###
	cross: (v) ->
		(@x * v.y) - (@y * v.x)

	### Computes the magnitude (length). ###
	mag: ->
		Math.sqrt @x*@x + @y*@y

	### Computes the squared magnitude (length). ###
	magSq: ->
		@x*@x + @y*@y

	### Computes the distance to another vector. ###
	dist: (v) ->
		dx = v.x - @x; dy = v.y - @y
		Math.sqrt dx*dx + dy*dy

	### Computes the squared distance to another vector. ###
	distSq: (v) ->
		dx = v.x - @x; dy = v.y - @y
		dx*dx + dy*dy

	### Normalises the vector, making it a unit vector (of length 1). ###
	norm: ->
		m = Math.sqrt @x*@x + @y*@y
		@x /= m
		@y /= m
		@

	### Limits the vector length to a given amount. ###
	limit: (l) ->
		mSq = @x*@x + @y*@y
		if mSq > l*l
			m = Math.sqrt mSq
			@x /= m; @y /= m
			@x *= l; @y *= l
			@

	### Copies components from another vector. ###
	copy: (v) ->
		@x = v.x; @y = v.y; @

	### Clones this vector to a new itentical one. ###
	clone: ->
		new Vector @x, @y

	### Resets the vector to zero. ###
	clear: ->
		@x = 0.0; @y = 0.0; @
