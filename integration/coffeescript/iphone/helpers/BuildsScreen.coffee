class BuildsScreenClass
  tableView: ->
    TravisCI.window().tableViews()['Builds']

  assertInView: ->
    assertTrue @tableView().isVisible()

  tapBuildNumber: (buildNumber) ->
    @tableView().cells()["Build ##{buildNumber} is still building"].tap()

    # assertWindow
    #   navigationBar:
    # if 
    #   UIALogger.logPass("Element #{el_name} is visible")
    # else
    #   UIALogger.logFail("Element #{el_name} is not visible")

BuildsScreen = new BuildsScreenClass
