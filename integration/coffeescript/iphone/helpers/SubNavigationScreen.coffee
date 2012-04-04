class SubNavigationScreen extends NavigationScreen
  back: ->
    @navigationBar().leftButton().tap()
