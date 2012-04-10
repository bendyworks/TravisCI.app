class JobDetailScreenClass extends SubNavigationScreen

  # tableView: ->
  #   TravisCI.window().tableViews()['Job Detail']

  # tapLog: ->
    # @tableView().cells()['Logs'].tap()

  assertLogEquals: (str) ->
    logView = TravisCI.window().textViews()['Log']

    logView.waitUntilVisible(3)
    assertEquals str, logView.value()

  assertInView: ->
    assertMatch /Job #\d+\.\d+/, TravisCI.window().navigationBar().name()

JobDetailScreen = new JobDetailScreenClass
