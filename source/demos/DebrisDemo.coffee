### DebrisDemo ###
class DebrisDemo extends Demo

    setup: (full = yes) ->

        super

        # Verlet gives us collision responce for free!
        @physics.integrator = new Verlet()
        @physics.viscosity = 0.08

        @pusher = new Particle()
        @pusher.collidable = yes
        @pusher.setRadius 32
        @pusher.setMass 1.0
        @pusher.fixed = yes
        @physics.particles.push @pusher

        min = new Vector 0.0, 0.0
        max = new Vector @width, @height

        bounds = new EdgeBounce min, max

        max = if full then 1000 else 500

        for i in [0..max]

            p = new Particle (Random 0.5, 1.0)
            p.setRadius p.mass * 10

            # Make it collidable
            p.collidable = yes

            p.moveTo new Vector (Random @width), (Random @height)
            p.behaviours.push bounds

            @physics.particles.push p

    mousemove: (event) =>

        super

        @pusher.pos.copy @mouse.pos
