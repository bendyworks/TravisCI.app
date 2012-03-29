class RepositoriesScreenClass extends NavigationScreen
  repositoryList: ->
    TravisCI.tableWithName('Repositories')

  tapRepositoryNamed: (name) ->
    @repositoryList().cells()[name].tap()

RepositoriesScreen = new RepositoriesScreenClass
