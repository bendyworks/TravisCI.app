class NavigationScreen
  navigationBar: ->
    TravisCI.window().navigationBar()

  back: ->
    @navigationBar().leftButton().tap()
