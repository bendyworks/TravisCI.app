class BuildsScreenClass extends SubNavigationScreen
  tableView: ->
    TravisCI.window().tableViews()['Builds']

  assertInView: ->
    assertTrue @tableView().isVisible()

  tapBuildNumber: (buildNumber) ->
    @tableView().cells()["Build ##{buildNumber} is still building"].tap()

  addToFavorites: (app) ->
    @navigationBar().rightButton().tap()
    app.actionSheet().elements().Add.tap()

  removeFromFavorites: (app) ->
    @navigationBar().rightButton().tap()
    app.actionSheet().elements().Remove.tap()

BuildsScreen = new BuildsScreenClass
