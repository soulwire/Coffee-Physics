### Attraction Behaviour ###

class Attraction extends Behaviour

    constructor: (@target = new Vector(), @radius = 1000, @strength = 100.0) ->

        @_delta = new Vector()
        @setRadius @radius

        super

    ### Sets the effective radius of the bahavious. ###
    setRadius: (radius) ->

        @radius = radius
        @radiusSq = radius * radius
    
    apply: (p, dt, index) ->

        #super p, dt, index

        # Vector pointing from particle to target.
        (@_delta.copy @target).sub p.pos

        # Squared distance to target.
        distSq = @_delta.magSq()

        # Limit force to behaviour radius.
        if distSq < @radiusSq and distSq > 0.000001

            # Calculate force vector.
            @_delta.norm().scale (1.0 - distSq / @radiusSq)

            #Apply force.
            p.acc.add @_delta.scale @strength
