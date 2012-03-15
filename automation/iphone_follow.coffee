assertElementPresent = (el, el_name) ->
  el_name = el_name ? el_name : ''
  if el.isValid()
    UIALogger.logPass("Element #{el_name} is present")
  else
    UIALogger.logFail("Element #{el_name} is not present")

window = () ->
  UIATarget.localTarget().frontMostApp().mainWindow()

whenITapTheFirstRepo = () ->
  repository_list = window().tableViews().firstWithName("Repositories")
  assertElementPresent(repository_list.cells(), "repository cells")
  latest_repo = repository_list.cells()[0]
  latest_repo.tap()

whenITapTheFollowButton = () ->
  button = window().navigationBar().rightButton()
  UIALogger.logDebug(button)

whenITapTheFirstRepo()
whenITapTheFollowButton()
