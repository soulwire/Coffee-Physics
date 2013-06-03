### Canvas Renderer ###
class CanvasRenderer extends Renderer

    constructor: ->

        super

        @canvas = document.createElement 'canvas'
        @ctx = @canvas.getContext '2d'

        # Set the DOM element.
        @domElement = @canvas
        @colours = {}

    init: (physics) ->

        super physics

        # Index colours for faster drawing
        r = 50
        for p in physics.particles

            ( @colours[ p.colour ] ?= items: [], canvas: do ->

                canvas = document.createElement 'canvas'
                canvas.width = canvas.height = r * 2

                ctx = canvas.getContext '2d'
                ctx.fillStyle = p.colour
                ctx.beginPath()
                ctx.arc r, r, r, 0, Math.PI * 2
                ctx.fill()

                canvas ).items.push p


    render: (physics) ->

        super physics

        time = new Date().getTime()

        # Draw velocity.
        vel = new Vector()

        # Draw heading.
        dir = new Vector()

        # Clear canvas.
        @ctx.clearRect 0, 0, @canvas.width, @canvas.height

        @ctx.globalCompositeOperation = 'lighter'
        @ctx.lineWidth = 1

        # Draw particles.
        if @renderParticles

            TWO_PI = Math.PI * 2

            for hex, obj of @colours

                img = obj.canvas

                for p in obj.items

                    size = p.radius * 2
                    @ctx.drawImage img, p.pos.x - p.radius, p.pos.y - p.radius, size, size

        if @renderSprings
        
            @ctx.strokeStyle = 'rgba(255,255,255,0.1)'
            @ctx.beginPath()

            for s in physics.springs

                @ctx.moveTo(s.p1.pos.x, s.p1.pos.y)
                @ctx.lineTo(s.p2.pos.x, s.p2.pos.y)

            @ctx.stroke()

        if @renderMouse
            
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
