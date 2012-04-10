#import "NavigationScreen.js"
#import "SubNavigationScreen.js"
#import "PopoverNavigationScreen.js"
#import "SubPopoverNavigationScreen.js"
#import "BuildsScreen.js"
#import "JobDetailScreen.js"
#import "JobsScreen.js"
#import "RepositoriesScreen.js"
#import "Pusher.js"

class TravisCIClass
  window: ->
    UIATarget.localTarget().frontMostApp().mainWindow()

  tableWithName: (name) ->
    @window().tableViews().firstWithName(name)

TravisCI = new TravisCIClass
