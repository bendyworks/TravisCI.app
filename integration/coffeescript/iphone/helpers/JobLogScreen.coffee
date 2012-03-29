class JobLogScreenClass
  textView: ->
    TravisCI.window().textViews()['Job Log']

  assertInView: ->
    assertTrue @textView().isVisible()

  assertLogEquals: (logText) ->
    assertEquals logText, @textView().value()

JobLogScreen = new JobLogScreenClass
