class FavoritesScreenClass extends NavigationScreen
  favoritesList: ->
    TravisCI.tableWithName('Repositories')

  assertFavoriteNamed: (name) ->
    assertTrue @favoritesList().cells()[name].isVisible()

  assertNoFavoriteNamed: (name) ->
    result = @favoritesList().cells()[name].isVisible()
    UIALogger.logDebug("should be true #{result}")
    assertFalse result

  tapAll: ->
    @navigationBar().elements().All.tap()

  tapFavoriteNamed: (name) ->
    @favoritesList().cells()[name].tap()


FavoritesScreen = new FavoritesScreenClass
