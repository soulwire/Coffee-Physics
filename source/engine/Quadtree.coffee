### Quadtree ###
Quadtree = do ->

    class Node

        constructor: ( @maxDepth = 4, @maxItems = 4, @depth = 0 ) ->

            @hasChildren = @depth < @maxDepth
            @hasDivided = no
            @items = []

            if @hasChildren

                @q1 = new Node @maxDepth, @maxItems, @depth + 1
                @q2 = new Node @maxDepth, @maxItems, @depth + 1
                @q3 = new Node @maxDepth, @maxItems, @depth + 1
                @q4 = new Node @maxDepth, @maxItems, @depth + 1

        resize: ( @x, @y, @w, @h ) ->

            @hw = @w / 2
            @hh = @h / 2

            @cx = @x + @hw
            @cy = @y + @hh

            if @hasChildren

                @q1.resize @x,  @y,  @hw, @hh
                @q2.resize @cx, @y,  @hw, @hh
                @q3.resize @cx, @cy, @hw, @hh
                @q4.resize @x,  @cy, @hw, @hh

        insert: ( item ) ->

            if @hasDivided

                # Select target quadrant

                if item.pos.y + item.radius < @cy # top

                         if item.pos.x + item.radius < @cx then quad = @q1 # left
                    else if item.pos.x - item.radius > @cx then quad = @q2 # right

                if item.pos.y - item.radius > @cy # bottom

                         if item.pos.x - item.radius > @cx then quad = @q3 # right
                    else if item.pos.x + item.radius < @cx then quad = @q4 # left

                # Cease processing this node and pass to child

                if quad

                    quad.insert item
                    return

            # Initially store item in this node

            @items.push item

            # Subdivide

            if @items.length >= @maxItems and @depth < @maxDepth

                @hasDivided = true

                # Reassign items

                for i in [ @items.length-1..0 ] by -1

                    item = @items[i]
                    quad = null

                    # Select target quadrant

                    if item.pos.y + item.radius < @cy # top

                             if item.pos.x + item.radius < @cx then quad = @q1 # left
                        else if item.pos.x - item.radius > @cx then quad = @q2 # right

                    if item.pos.y1 > @cy # bottom

                             if item.pos.x - item.radius > @cx then quad = @q3 # right
                        else if item.pos.x + item.radius < @cx then quad = @q4 # left

                    # Reassign item

                    if quad

                        @items.splice i, 1
                        quad.insert item

        update: ( particles ) ->

            do @clear

            @insert particle for particle in particles

        search: ( item, buffer = [] ) ->

            buffer = buffer || []

            # Select target quadrant

            if item.pos.y + item.radius < @cy # top

                     if item.pos.x + item.radius < @cx then quad = @q1 # left
                else if item.pos.x - item.radius > @cx then quad = @q2 # right

            if item.pos.y - item.radius > @cy # bottom

                     if item.pos.x - item.radius > @cx then quad = @q3 # right
                else if item.pos.x + item.radius < @cx then quad = @q4 # left

            # Search child nodes

            if quad and @hasDivided

                quad.search item, buffer

            # Push in items

            buffer.push item for item in @items

            buffer

        clear: ->

            @hasDivided = false
            @items.length = 0

            if @hasChildren

                do @q1.clear
                do @q2.clear
                do @q3.clear
                do @q4.clear

        draw: ( ctx ) ->

            ctx.strokeStyle = 'rgba(255,0,255,0.25)'
            ctx.lineWidth = 1
            ctx.strokeRect @x, @y, @w, @h

            if @hasChildren and @hasDivided

                @q1.draw ctx
                @q2.draw ctx
                @q3.draw ctx
                @q4.draw ctx

    Node