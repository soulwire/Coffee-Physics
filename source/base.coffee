### Allows safe, dyamic creation of namespaces. ###

namespace = (id) ->
	root = self
	root = root[path] ?= {} for path in id.split '.'

### RequestAnimationFrame shim. ###
do ->

    time = 0
    vendors = ['ms', 'moz', 'webkit', 'o']

    for vendor in vendors when not window.requestAnimationFrame
        window.requestAnimationFrame = window[ vendor + 'RequestAnimationFrame']
        window.cancelAnimationFrame = window[ vendor + 'CancelAnimationFrame']

    if not window.requestAnimationFrame

        window.requestAnimationFrame = (callback, element) ->
            now = new Date().getTime()
            delta = Math.max 0, 16 - (now - old)
            setTimeout (-> callback(time + delta)), delta
            old = now + delta

    if not window.cancelAnimationFrame
        
        window.cancelAnimationFrame = (id) ->
            clearTimeout id
