### Canvas Renderer ###
class CanvasRenderer extends Renderer

    constructor: ->

        super

        @canvas = document.createElement 'canvas'
        @ctx = @canvas.getContext '2d'

        @pad = new Vector 2.0, 2.0
        @min = new Vector
        @max = new Vector

        # Set the DOM element.
        @domElement = @canvas

    init: (physics) ->

        super physics

    render: (physics) ->

        super physics

        time = new Date().getTime()

        # Draw velocity.
        vel = new Vector()

        # Draw heading.
        dir = new Vector()

        # Clear canvas.
        @min.sub @pad
        @max.add @pad
        @ctx.clearRect @min.x, @min.y, @max.x - @min.x, @max.y - @min.y

        @ctx.globalCompositeOperation = 'lighter'
        @ctx.lineWidth = 1

        # Compute redraw region.
        @max.set 0.0, 0.0
        @min.set @width, @height

        for p in physics.particles

            @min.x = Math.min @min.x, p.pos.x - p.radius
            @min.y = Math.min @min.y, p.pos.y - p.radius
            @max.x = Math.max @max.x, p.pos.x + p.radius
            @max.y = Math.max @max.y, p.pos.y + p.radius

        # Draw particles.
        if @renderParticles

            TWO_PI = Math.PI * 2
        
            for p in physics.particles

                @ctx.beginPath()
                @ctx.arc(p.pos.x, p.pos.y, p.radius, 0, TWO_PI, no)

                @ctx.fillStyle = '#' + (p.colour or 'FFFFFF')
                @ctx.fill()

                # @ctx.save()

                # @ctx.translate(p.pos.x, p.pos.y)
                # @ctx.beginPath()
                # @ctx.arc(0, 0, p.radius, 0, Math.PI * 2)

                # @ctx.fillStyle = '#' + (p.colour or 'FFFFFF')
                # @ctx.fill()

                # Draw velocity.

                # vel.copy p.vel
                # vel.scale 0.1

                # @ctx.beginPath()
                # @ctx.moveTo(0, 0)
                # @ctx.lineTo(vel.x, vel.y)

                # @ctx.strokeStyle = 'rgba(0,255,255,0.5)'
                # @ctx.stroke()

                # # Draw heading.

                # (dir.copy p.pos).sub p.old.pos
                # dir.scale 4

                # @ctx.beginPath()
                # @ctx.moveTo(0, 0)
                # @ctx.lineTo(dir.x, dir.y)

                # @ctx.strokeStyle = 'rgba(255,0,255,0.5)'
                # @ctx.stroke()

                @ctx.restore()

        if @renderSprings
        
            @ctx.strokeStyle = 'rgba(255,255,255,0.1)'

            # Draw springs.
            for s in physics.springs

                @ctx.beginPath()
                @ctx.moveTo(s.p1.pos.x, s.p1.pos.y)
                @ctx.lineTo(s.p2.pos.x, s.p2.pos.y)
                @ctx.stroke()

        if @renderMouse

            @min.x = Math.min @min.x, @mouse.pos.x - 20
            @min.y = Math.min @min.y, @mouse.pos.y - 20
            @max.x = Math.max @max.x, @mouse.pos.x + 20
            @max.y = Math.max @max.y, @mouse.pos.y + 20
            
            # Draw mouse.
            @ctx.fillStyle = 'rgba(255,255,255,0.1)'
            @ctx.beginPath()
            @ctx.arc(@mouse.pos.x, @mouse.pos.y, 20, 0, TWO_PI)
            @ctx.fill()

        @renderTime = new Date().getTime() - time

    setSize: (@width, @height) =>

        super @width, @height

        @canvas.width = @width
        @canvas.height = @height
