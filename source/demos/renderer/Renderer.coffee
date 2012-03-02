### Base Renderer ###
class Renderer

    constructor: ->

        @width = 0
        @height = 0

        @renderParticles = true
        @renderSprings = true
        @renderMouse = true
        @initialized = false
        @renderTime = 0

    init: (physics) ->

        @initialized = true

    render: (physics) ->

        if not @initialized then @init physics

    setSize: (@width, @height) =>

    destroy: ->

        
