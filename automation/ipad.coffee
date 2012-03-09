assertElementPresent = (el, el_name) ->
  el_name ?= ''
  if el.isValid()
    return UIALogger.logPass("Element #{el_name} is present")
  else
    return UIALogger.logFail("Element #{el_name} is not present")

whenITapTheNavigationMenuButton = () ->
  window = UIATarget.localTarget().frontMostApp().mainWindow()
  window.navigationBar().leftButton().tap()

whenITapThePopoverLeftNavButton = () ->
  window = UIATarget.localTarget().frontMostApp().mainWindow()
  window.popover().navigationBar().leftButton().tap()

whenITapTheFirstRepo = () ->
  window = UIATarget.localTarget().frontMostApp().mainWindow()
  repository_list = window.popover().tableViews().firstWithName("Repositories")
  assertElementPresent(repository_list.cells(), "repository cells")
  latest_repo = repository_list.cells()[0]
  latest_repo.tap()

whenITapTheSecondRepo = () ->
  window = UIATarget.localTarget().frontMostApp().mainWindow()
  repository_list = window.popover().tableViews().firstWithName("Repositories")
  assertElementPresent(repository_list.cells(), "repository cells")
  second_repo = repository_list.cells()[1]
  second_repo.tap()

whenITapTheFirstBuild = () ->
  window = UIATarget.localTarget().frontMostApp().mainWindow()
  # Then I should see the list of builds
  build_list = window.popover().tableViews().firstWithName("Builds")
  assertElementPresent(build_list.cells())
  build_cell = build_list.cells()[0]
  assertElementPresent(build_cell, "build_cell")
  build_cell.tap()

whenITapTheFirstJob = () ->
  window = UIATarget.localTarget().frontMostApp().mainWindow()
  job_list = window.popover().tableViews().firstWithName("Jobs")
  assertElementPresent(job_list.cells(), "job list cells()")
  job_cell = job_list.cells()[0]
  assertElementPresent(job_list.cells(), "first job cell")
  job_cell.tap()

thenIShouldSeeTheJobLog = (logValue) ->
  window = UIATarget.localTarget().frontMostApp().mainWindow()
  log = window.textViews()[0]
  if (log.value() == logValue)
    UIALogger.logPass("log displayed correctly")
  else
    UIALogger.logFail("log is not correct")

whenPusherSendsAnUpdateAboutThatJob = (job_id, new_log_line) ->
  path = "/Users/bendyworks/dev/ios/TravisCI/automation/pusher_event"
  args = [
    "job-#{job_id}"
    "job:log"
    """{"id" : #{job_id}, "_log" : "#{new_log_line}"}"""
  ]
  timeout = 5; # seconds
  host = UIATarget.localTarget().host()
  result = host.performTaskWithPathArgumentsTimeout(path, args, timeout)
  if result.exitCode == 0
    UIALogger.logPass("Pusher Scripted Called")
  else
    UIALogger.logPass("Pusher Script had an error: #{result.stderr} #{result.stdout}")


whenITapTheNavigationMenuButton()
whenITapTheFirstRepo()
whenITapTheFirstBuild()
whenITapTheFirstJob()

logLineOne = "log line one\n"
thenIShouldSeeTheJobLog(logLineOne)

new_log_line = "log line 2"
whenPusherSendsAnUpdateAboutThatJob("110", new_log_line)
thenIShouldSeeTheJobLog(logLineOne + new_log_line)


# When I navigate back (Job #7.1 -> Build #3 -> Travis-ci/CITravis -> Repositories)
whenITapTheNavigationMenuButton()
whenITapThePopoverLeftNavButton() # goto build list
whenITapThePopoverLeftNavButton() # goto repo list

# And I select a job from another repository
whenITapTheSecondRepo()
whenITapTheFirstBuild()
whenITapTheFirstJob()

logLineOne = "first log line\n"
thenIShouldSeeTheJobLog(logLineOne)

new_log_line = "z second log line"
whenPusherSendsAnUpdateAboutThatJob("210", new_log_line)
thenIShouldSeeTheJobLog(logLineOne + new_log_line)
