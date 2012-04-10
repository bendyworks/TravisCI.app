class PopoverNavigationScreen
  popover: ->
    TravisCI.window().popover()

  navigationBar: ->
    @popover().navigationBar()

  windowNavigationBar: ->
    UIALogger.logDebug('windowNavigationBar')
    TravisCI.window().navigationBar()
