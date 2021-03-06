class JobsScreenClass extends SubPopoverNavigationScreen
  tableView: ->
    @popover().tableViews()['Jobs']

  assertInView: ->
    assertTrue @tableView().isVisible()

  tapJobNumber: (jobNumber) ->
    @tableView().cells()["Job #{jobNumber} for node_js 0.4"].tap()

JobsScreen = new JobsScreenClass
