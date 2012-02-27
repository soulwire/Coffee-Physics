### Velocity Verlet Integrator ###

class Verlet extends Integrator
    
    # v = x - ox
    # x = x + (v + a * dt * dt)

    integrate: (particles, dt, drag) ->

        pos = new Vector()

        dtSq = dt * dt

        for p in particles when not p.fixed

            # Scale force to mass.
            p.acc.scale p.massInv

            # Derive velocity.
            (p.vel.copy p.pos).sub p.old.pos

            # Apply friction.
            if drag then p.vel.scale drag

            # Apply forces to new position.
            (pos.copy p.pos).add (p.vel.add p.acc.scale dtSq)

            # Store old position.
            p.old.pos.copy p.pos

            # update position.
            p.pos.copy pos

            # Reset forces.
            p.acc.clear()

