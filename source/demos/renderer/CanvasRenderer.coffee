### Canvas Renderer ###
class CanvasRenderer extends Renderer

    constructor: ->

        super

        @canvas = document.createElement 'canvas'
        @ctx = @canvas.getContext '2d'

        # Set the DOM element.
        @domElement = @canvas

    init: (physics) ->

        super physics

    render: (physics) ->

        super physics

        # Draw velocity.
        vel = new Vector()

        # Draw heading.
        dir = new Vector()

        # Clear canvas.
        @canvas.width = @width

        @ctx.globalCompositeOperation = 'lighter'
        @ctx.lineWidth = 1

        # Draw particles.
        if @renderParticles
        
            for p in physics.particles

                @ctx.save()

                @ctx.translate(p.pos.x, p.pos.y)
                @ctx.beginPath()
                @ctx.arc(0, 0, p.radius, 0, Math.PI * 2)

                @ctx.fillStyle = p.colour or '#FFFFFF'
                @ctx.fill()

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
            
            # Draw mouse.
            @ctx.fillStyle = 'rgba(255,255,255,0.1)'
            @ctx.beginPath()
            @ctx.arc(@mouse.pos.x, @mouse.pos.y, 20, 0, Math.PI * 2)
            @ctx.fill()

    setSize: (@width, @height) =>

        super @width, @height

        @canvas.width = @width
        @canvas.height = @height
