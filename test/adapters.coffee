{createReadStream} = require "fs"

assert = require "assert"
Amen = require "amen"

{producer, pull, repeat, events, stream, flow} = require "../src/adapters"
{lines} = require "../src/filters"

Amen.describe "Adapters", (context) ->

  context.test "events", ->
    i = events "data", createReadStream "test/data/lines.txt"
    assert (yield i()).value.toString() == "one\ntwo\nthree\n"
    assert (yield i()).done

  context.test "stream", ->
    i = stream createReadStream "test/data/lines.txt"
    assert ((yield i()).value.toString() == "one\ntwo\nthree\n")
    assert (yield i()).done

  context.test "flow", ->

    i = flow [
      stream createReadStream "./test/data/lines.txt"
      lines
    ]

    assert (yield i()).value == "one"
    assert (yield i()).value == "two"
    assert (yield i()).value == "three"
    assert (yield i().done)
