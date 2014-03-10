### Collision Behaviour ###

# TODO: Collision response for non Verlet integrators.

class Collision extends Behaviour

    constructor: (@useMass = yes, @callback = null) ->

        # Pool of collidable particles.
        @pool = []

        # Delta between particle positions.
        @_delta = new Vector()

        super

    apply: (p, dt, index) ->

        #super p, dt, index

        # Check pool for collisions.
        for o in @pool[index..] when o isnt p

            # Delta between particles positions.
            (@_delta.copy o.pos).sub p.pos

            # Squared distance between particles.
            distSq = @_delta.magSq()

            # Sum of both radii.
            radii = p.radius + o.radius

            # Check if particles collide.
            if distSq <= radii * radii

                # Compute real distance.
                dist = Math.sqrt distSq

                # Determine overlap.
                overlap = radii - dist
                overlap += 0.5

                # Total mass.
                mt = p.mass + o.mass

                # Distribute collision responses.
                r1 = if @useMass then o.mass / mt else 0.5
                r2 = if @useMass then p.mass / mt else 0.5

                # Move particles so they no longer overlap.
                p.pos.add (@_delta.clone().norm().scale overlap * -r1)
                o.pos.add (@_delta.norm().scale overlap * r2)

                # Fire callback if defined.
                @callback?(p, o, overlap)