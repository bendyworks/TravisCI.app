class JobDetailScreenClass

  tableView: ->
    TravisCI.window().tableViews()['Job Detail']

  tapLog: ->
    @tableView().cells()['Logs'].tap()

  assertInView: ->
    assertTrue @tableView().isVisible()

JobDetailScreen = new JobDetailScreenClass
