### Random ###

Random = (min, max) ->

	if not max?
			max = min
			min = 0
			
	min + Math.random() * (max - min)

Random.int = (min, max) ->

	if not max?
			max = min
			min = 0
			
	Math.floor min + Math.random() * (max - min)

Random.sign = (prob = 0.5) ->

	if do Math.random < prob then 1 else -1

Random.bool = (prob = 0.5) ->

	do Math.random < prob

Random.item = (list) ->

	list[ Math.floor Math.random() * list.length ]