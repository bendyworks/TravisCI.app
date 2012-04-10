class SubPopoverNavigationScreen extends PopoverNavigationScreen
  back: ->
    @navigationBar().leftButton().tap()
