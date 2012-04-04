#import "NavigationScreen.js"
#import "SubNavigationScreen.js"
#import "Pusher.js"
#import "RepositoriesScreen.js"
#import "BuildsScreen.js"
#import "JobsScreen.js"
#import "JobDetailScreen.js"
#import "JobLogScreen.js"
#import "FavoritesScreen.js"

class TravisCIClass
  window: ->
    UIATarget.localTarget().frontMostApp().mainWindow()

  tableWithName: (name) ->
    @window().tableViews().firstWithName(name)

TravisCI = new TravisCIClass
