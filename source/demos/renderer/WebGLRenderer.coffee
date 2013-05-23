### WebGL Renderer ###

class WebGLRenderer extends Renderer

    # Particle vertex shader source.
    @PARTICLE_VS = '''

        uniform vec2 viewport;
        attribute vec3 position;
        attribute float radius;
        attribute vec4 colour;
        varying vec4 tint;

        void main() {

            // convert the rectangle from pixels to 0.0 to 1.0
            vec2 zeroToOne = position.xy / viewport;
            zeroToOne.y = 1.0 - zeroToOne.y;

            // convert from 0->1 to 0->2
            vec2 zeroToTwo = zeroToOne * 2.0;

            // convert from 0->2 to -1->+1 (clipspace)
            vec2 clipSpace = zeroToTwo - 1.0;

            tint = colour;

            gl_Position = vec4(clipSpace, 0, 1);
            gl_PointSize = radius * 2.0;
        }
    '''

    # Particle fragent shader source.
    @PARTICLE_FS = '''

        precision mediump float;
        
        uniform sampler2D texture;
        varying vec4 tint;

        void main() {
            gl_FragColor = texture2D(texture, gl_PointCoord) * tint;
        }
    '''

    # Spring vertex shader source.
    @SPRING_VS = '''

        uniform vec2 viewport;
        attribute vec3 position;

        void main() {

            // convert the rectangle from pixels to 0.0 to 1.0
            vec2 zeroToOne = position.xy / viewport;
            zeroToOne.y = 1.0 - zeroToOne.y;

            // convert from 0->1 to 0->2
            vec2 zeroToTwo = zeroToOne * 2.0;

            // convert from 0->2 to -1->+1 (clipspace)
            vec2 clipSpace = zeroToTwo - 1.0;

            gl_Position = vec4(clipSpace, 0, 1);
        }
    '''

    # Spring fragent shader source.
    @SPRING_FS = '''

        void main() {
            gl_FragColor = vec4(1.0, 1.0, 1.0, 0.1);
        }
    '''

    constructor: (@usePointSprites = true) ->

        super

        @particlePositionBuffer = null
        @particleRadiusBuffer = null
        @particleColourBuffer = null
        @particleTexture = null
        @particleShader = null

        @springPositionBuffer = null
        @springShader = null

        @canvas = document.createElement 'canvas'
        
        # Init WebGL.
        try @gl = @canvas.getContext 'experimental-webgl' catch error
        finally return new CanvasRenderer() if not @gl

        # Set the DOM element.
        @domElement = @canvas

    init: (physics) ->

        super physics

        @initShaders()
        @initBuffers physics

        # Create particle texture from canvas.
        @particleTexture = do @createParticleTextureData

        # Use additive blending.
        @gl.blendFunc @gl.SRC_ALPHA, @gl.ONE

        # Enable the other shit we need from WebGL.
        #@gl.enable @gl.VERTEX_PROGRAM_POINT_SIZE
        #@gl.enable @gl.TEXTURE_2D
        @gl.enable @gl.BLEND

    initShaders: ->

        # Create shaders.
        @particleShader = @createShaderProgram WebGLRenderer.PARTICLE_VS, WebGLRenderer.PARTICLE_FS
        @springShader = @createShaderProgram WebGLRenderer.SPRING_VS, WebGLRenderer.SPRING_FS

        # Store particle shader uniform locations.
        @particleShader.uniforms =
            viewport: @gl.getUniformLocation @particleShader, 'viewport'

        # Store spring shader uniform locations.
        @springShader.uniforms =
            viewport: @gl.getUniformLocation @springShader, 'viewport'

        # Store particle shader attribute locations.
        @particleShader.attributes =
            position: @gl.getAttribLocation @particleShader, 'position'
            radius: @gl.getAttribLocation @particleShader, 'radius'
            colour: @gl.getAttribLocation @particleShader, 'colour'

        # Store spring shader attribute locations.
        @springShader.attributes =
            position: @gl.getAttribLocation @springShader, 'position'

        console.log @particleShader

    initBuffers: (physics) ->

        colours = []
        radii = []

        # Create buffers.
        @particlePositionBuffer = do @gl.createBuffer
        @springPositionBuffer = do @gl.createBuffer
        @particleColourBuffer = do @gl.createBuffer
        @particleRadiusBuffer = do @gl.createBuffer

        # Create attribute arrays.
        for particle in physics.particles

            # Break the colour string into RGBA components.
            rgba = (particle.colour or '#FFFFFF').match(/[\dA-F]{2}/gi)
            
            # Parse into integers.
            r = (parseInt rgba[0], 16) or 255
            g = (parseInt rgba[1], 16) or 255
            b = (parseInt rgba[2], 16) or 255
            a = (parseInt rgba[3], 16) or 255

            # Prepare for adding to the colour buffer.
            colours.push r / 255, g / 255, b / 255, a / 255

            # Prepare for adding to the radius buffer.
            radii.push particle.radius or 32

        # Init Particle colour buffer.
        @gl.bindBuffer @gl.ARRAY_BUFFER, @particleColourBuffer
        @gl.bufferData @gl.ARRAY_BUFFER, new Float32Array(colours), @gl.STATIC_DRAW

        # Init Particle radius buffer.
        @gl.bindBuffer @gl.ARRAY_BUFFER, @particleRadiusBuffer
        @gl.bufferData @gl.ARRAY_BUFFER, new Float32Array(radii), @gl.STATIC_DRAW

        ## console.log @particleColourBuffer

    # Creates a generic texture for particles.
    createParticleTextureData: (size = 128) ->
        
        canvas = document.createElement 'canvas'
        canvas.width = canvas.height = size
        ctx = canvas.getContext '2d'
        rad = size * 0.5
        
        ctx.beginPath()
        ctx.arc rad, rad, rad, 0, Math.PI * 2, false
        ctx.closePath()

        ctx.fillStyle = '#FFF'
        ctx.fill()

        texture = @gl.createTexture()
        @setupTexture texture, canvas

        texture

    # Creates a WebGL texture from an image path or data.
    loadTexture: (source) ->

        texture = @gl.createTexture()
        texture.image = new Image()

        texture.image.onload = =>

            @setupTexture texture, texture.image
        
        texture.image.src = source
        texture

    setupTexture: (texture, data) ->

        @gl.bindTexture @gl.TEXTURE_2D, texture
        @gl.texImage2D @gl.TEXTURE_2D, 0, @gl.RGBA, @gl.RGBA, @gl.UNSIGNED_BYTE, data
        @gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_MIN_FILTER, @gl.LINEAR
        @gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_MAG_FILTER, @gl.LINEAR
        @gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_WRAP_S, @gl.CLAMP_TO_EDGE
        @gl.texParameteri @gl.TEXTURE_2D, @gl.TEXTURE_WRAP_T, @gl.CLAMP_TO_EDGE
        @gl.generateMipmap @gl.TEXTURE_2D
        @gl.bindTexture @gl.TEXTURE_2D, null

        texture

    # Creates a shader program from vertex and fragment shader sources.
    createShaderProgram: (_vs, _fs) ->

        vs = @gl.createShader @gl.VERTEX_SHADER
        fs = @gl.createShader @gl.FRAGMENT_SHADER

        @gl.shaderSource vs, _vs
        @gl.shaderSource fs, _fs

        @gl.compileShader vs
        @gl.compileShader fs

        if not @gl.getShaderParameter vs, @gl.COMPILE_STATUS
            alert @gl.getShaderInfoLog vs
            null

        if not @gl.getShaderParameter fs, @gl.COMPILE_STATUS
            alert @gl.getShaderInfoLog fs
            null

        prog = do @gl.createProgram

        @gl.attachShader prog, vs
        @gl.attachShader prog, fs
        @gl.linkProgram prog

        ## console.log 'Vertex Shader Compiled', @gl.getShaderParameter vs, @gl.COMPILE_STATUS
        ## console.log 'Fragment Shader Compiled', @gl.getShaderParameter fs, @gl.COMPILE_STATUS
        ## console.log 'Program Linked', @gl.getProgramParameter prog, @gl.LINK_STATUS

        prog

    # Sets the size of the viewport.
    setSize: (@width, @height) =>

        ## console.log 'resize', @width, @height

        super @width, @height

        @canvas.width = @width
        @canvas.height = @height
        @gl.viewport 0, 0, @width, @height

        # Update shader uniforms.
        @gl.useProgram @particleShader
        @gl.uniform2fv @particleShader.uniforms.viewport, new Float32Array [@width, @height]

        # Update shader uniforms.
        @gl.useProgram @springShader
        @gl.uniform2fv @springShader.uniforms.viewport, new Float32Array [@width, @height]

    # Renders the current physics state.
    render: (physics) ->

        super

        # Clear the viewport.
        @gl.clear @gl.COLOR_BUFFER_BIT | @gl.DEPTH_BUFFER_BIT

        # Draw particles.
        if @renderParticles

            vertices = []

            # Update particle positions.
            for p in physics.particles
                vertices.push p.pos.x, p.pos.y, 0.0

            # Bind the particle texture.
            @gl.activeTexture @gl.TEXTURE0
            @gl.bindTexture @gl.TEXTURE_2D, @particleTexture

            # Use the particle program.
            @gl.useProgram @particleShader

            # Setup vertices.
            @gl.bindBuffer @gl.ARRAY_BUFFER, @particlePositionBuffer
            @gl.bufferData @gl.ARRAY_BUFFER, new Float32Array(vertices), @gl.STATIC_DRAW
            @gl.vertexAttribPointer @particleShader.attributes.position, 3, @gl.FLOAT, false, 0, 0
            @gl.enableVertexAttribArray @particleShader.attributes.position

            # Setup colours.
            @gl.bindBuffer @gl.ARRAY_BUFFER, @particleColourBuffer
            @gl.enableVertexAttribArray @particleShader.attributes.colour
            @gl.vertexAttribPointer @particleShader.attributes.colour, 4, @gl.FLOAT, false, 0, 0

            # Setup radii.
            @gl.bindBuffer @gl.ARRAY_BUFFER, @particleRadiusBuffer
            @gl.enableVertexAttribArray @particleShader.attributes.radius
            @gl.vertexAttribPointer @particleShader.attributes.radius, 1, @gl.FLOAT, false, 0, 0

            # Draw particles.
            @gl.drawArrays @gl.POINTS, 0, vertices.length / 3

        # Draw springs.
        if @renderSprings and physics.springs.length > 0

            vertices = []

            # Update spring positions.
            for s in physics.springs
                vertices.push s.p1.pos.x, s.p1.pos.y, 0.0
                vertices.push s.p2.pos.x, s.p2.pos.y, 0.0

            # Use the spring program.
            @gl.useProgram @springShader

            # Setup vertices.
            @gl.bindBuffer @gl.ARRAY_BUFFER, @springPositionBuffer
            @gl.bufferData @gl.ARRAY_BUFFER, new Float32Array(vertices), @gl.STATIC_DRAW
            @gl.vertexAttribPointer @springShader.attributes.position, 3, @gl.FLOAT, false, 0, 0
            @gl.enableVertexAttribArray @springShader.attributes.position

            # Draw springs.
            @gl.drawArrays @gl.LINES, 0, vertices.length / 3

    destroy: ->

        ## console.log 'Destroy'
