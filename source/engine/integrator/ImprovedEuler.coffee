### Improved Euler Integrator ###

class ImprovedEuler extends Integrator

    # x += (v * dt) + (a * 0.5 * dt * dt)
    # v += a * dt

    integrate: (particles, dt, drag) ->

        acc = new Vector()
        vel = new Vector()

        dtSq = dt * dt

        for p in particles when not p.fixed

            # Store previous location.
            p.old.pos.copy p.pos

            # Scale force to mass.
            p.acc.scale p.massInv

            # Duplicate velocity to preserve momentum.
            vel.copy p.vel

            # Duplicate force.
            acc.copy p.acc

            # Update position.
            p.pos.add (vel.scale dt).add (acc.scale 0.5 * dtSq)

            # Update velocity.
            p.vel.add p.acc.scale dt

            # Apply friction.
            if drag then p.vel.scale drag

            # Reset forces.
            p.acc.clear()
