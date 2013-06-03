### Collision Behaviour ###
Collision =

    apply: (p1, p2, useMass = yes) ->

        # Delta between particles positions.
        delta = Vector.sub p2.pos, p1.pos

        # Squared distance between particles.
        distSq = delta.magSq()

        # Sum of both radii.
        radii = p1.radius + p2.radius

        # Check if particles collide.
        if distSq <= radii * radii

            # Compute real distance.
            dist = Math.sqrt distSq

            # Determine overlap.
            overlap = (p1.radius + p2.radius) - dist
            overlap += 0.5

            # Total mass.
            mt = p1.mass + p2.mass

            # Distribute collision responses.
            r1 = if useMass then p2.mass / mt else 0.5
            r2 = if useMass then p1.mass / mt else 0.5

            # Move particles so they no longer overlap.
            p1.pos.add delta.clone().norm().scale overlap * -r1
            p2.pos.add delta.norm().scale overlap * r2