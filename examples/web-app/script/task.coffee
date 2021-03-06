{start, flow, map, pull, async, isString, asyncIterator} = require "fairmont"
{pull} = require "../../../src"

apply = async (f) -> yield f()

_tasks = {}
lookup = (name) ->
  if (_task = _tasks[name])?
    _task
  else
    console.error "Warning: Task '#{name}' is not defined."
    (async -> yield null)

task = async (name, tasks..., f) ->

  if arguments.length == 0
    yield _tasks.default()

  else if arguments.length == 1
    yield _tasks[name]()

  else

    if isString f
      tasks.push f
      f = undefined

    started = false
    _tasks[name] = async ->
      if !started
        started = true
        console.log "Task '#{name}' is starting…"
        {collect} = require "fairmont"
        resets = yield collect flow [
          tasks
          map lookup
          map apply
          pull
        ]
        yield f?()
        console.log "Task '#{name}' is done."
        started = false

module.exports = {task}
