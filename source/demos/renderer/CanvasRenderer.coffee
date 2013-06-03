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
        ( @colours[ p.colour ] ?= [] ).push p for p in physics.particles

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

            for hex, list of @colours

                @ctx.fillStyle = '#' + (hex or 'FFFFFF')

                for p in list

                    @ctx.beginPath()
                    @ctx.arc(p.pos.x, p.pos.y, p.radius, 0, TWO_PI, no)
                    @ctx.fill()

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
