### CollisionDemo ###
class CollisionDemo extends Demo

    setup: (full = yes) ->

        super

        # Verlet gives us collision responce for free!
        @physics.integrator = new Verlet()

        min = new Vector 0.0, 0.0
        max = new Vector @width, @height

        bounds = new EdgeBounce min, max
        collide = new Collision
        attraction = new Attraction @mouse.pos, 2000, 1400

        max = if full then 350 else 150
        prob = if full then 0.35 else 0.5

        for i in [0..max]

            p = new Particle (Random 0.5, 4.0)
            p.setRadius p.mass * 4

            p.moveTo new Vector (Random @width), (Random @height)

            # Connect to spring or move free.
            if Random.bool prob
                s = new Spring @mouse, p, (Random 120, 180), 0.8
                @physics.springs.push s
            else
                p.behaviours.push attraction

            # Add particle to collision pool.
            collide.pool.push p

            # Allow particle to collide.
            p.behaviours.push collide
            p.behaviours.push bounds

            @physics.particles.push p

    onCollision: (p1, p2) =>

        # Respond to collision.

