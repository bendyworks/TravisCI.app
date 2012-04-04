class JobsScreenClass extends SubNavigationScreen
  tableView: ->
    TravisCI.window().tableViews()['Jobs']

  assertInView: ->
    assertTrue @tableView().isVisible()

  tapJobNumber: (jobNumber) ->
    @tableView().cells()["Job #{jobNumber} for node_js 0.4"].tap()

JobsScreen = new JobsScreenClass
