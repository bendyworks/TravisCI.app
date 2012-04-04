class RepositoriesScreenClass extends NavigationScreen
  repositoryList: ->
    TravisCI.tableWithName('Repositories')

  tapRepositoryNamed: (name) ->
    @repositoryList().cells()[name].tap()

  tapFavorites: ->
    @navigationBar().elements().Favorites.tap()

RepositoriesScreen = new RepositoriesScreenClass
