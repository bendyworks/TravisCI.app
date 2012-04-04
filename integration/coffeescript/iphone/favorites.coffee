#import "../../../../Pods/tuneup_js/tuneup.js"

#import "helpers/TravisCI.js"

test 'Favoriting a repository', (target, app) ->
  RepositoriesScreen.tapRepositoryNamed 'CITravis by Travis-ci'
  BuildsScreen.addToFavorites(app)
  BuildsScreen.back()
  RepositoriesScreen.tapFavorites()
  FavoritesScreen.assertFavoriteNamed 'CITravis by Travis-ci'
  FavoritesScreen.tapAll()

test 'Unfavoriting a repository', (target, app) ->
  RepositoriesScreen.tapFavorites()
  FavoritesScreen.assertFavoriteNamed 'CITravis by Travis-ci'
  FavoritesScreen.tapFavoriteNamed 'CITravis by Travis-ci'
  BuildsScreen.removeFromFavorites(app)
  BuildsScreen.back()
  FavoritesScreen.assertNoFavoriteNamed 'CITravis by Travis-ci'
  FavoritesScreen.tapAll()

