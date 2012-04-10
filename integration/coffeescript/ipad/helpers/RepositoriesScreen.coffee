class RepositoriesScreenClass extends PopoverNavigationScreen
  reveal: ->
    @windowNavigationBar().leftButton().tap()
    UIALogger.logDebug("after tapping repositories")

  repositoryList: ->
    @popover().tableViews()['Repositories']

  tapRepositoryNamed: (name) ->
    UIALogger.logDebug("#{@repositoryList()}")
    @repositoryList().cells()[name].tap()

  tapFavorites: ->
    @navigationBar().elements().Favorites.tap()

RepositoriesScreen = new RepositoriesScreenClass
