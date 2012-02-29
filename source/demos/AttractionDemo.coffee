class AttractionDemo extends Demo

    setup: ->

        super

        min = new Vector 0.0, 0.0
        max = new Vector @width, @height
        
        bounds = new EdgeBounce min, max

        @physics.integrator = new Verlet()

        attraction = new Attraction @mouse.pos, 1200, 1200
        repulsion = new Attraction @mouse.pos, 200, -2000
        collide = new Collision()

        for i in [0..400]

            p = new Particle (Random 0.1, 3.0)
            p.setRadius p.mass * 4

            p.moveTo new Vector (Random @width), (Random @height)

            p.behaviours.push attraction
            p.behaviours.push repulsion
            p.behaviours.push bounds
            p.behaviours.push collide

            collide.pool.push p

            @physics.particles.push p