assertElementPresent = (el, el_name) ->
  el_name = el_name ? el_name : ''
  if el.isValid()
    UIALogger.logPass("Element #{el_name} is present")
  else
    UIALogger.logFail("Element #{el_name} is not present")

whenPusherSendsAnUpdateAboutThatJob = (target, job_id, new_log_line) ->
  path = "/Users/bendyworks/dev/ios/TravisCI/automation/pusher_event"
  args = [
    "job-#{job_id}"
    "job:log"
    """{"id" : #{job_id}, "_log" : "#{new_log_line}"}"""
  ]
  timeout = 5; # seconds
  host = target.host()
  result = host.performTaskWithPathArgumentsTimeout(path, args, timeout)

  if result.exitCode == 0
    UIALogger.logPass("Pusher Scripted Called")
  else
    UIALogger.logPass("Pusher Script had an error: #{result.stderr} #{result.stdout}")


givenISeeRepositoryList = (window) ->
  repository_list = window.tableViews().firstWithName("Repositories")
  assertElementPresent(repository_list.cells(), "repository cells")
  repository_list

whenITapTheFirstRepo = (repository_list) ->
  latest_repo = repository_list.cells()[0]
  latest_repo.tap()

thenIShouldSeeTheListOfBuilds = (window) ->
  build_list = window.tableViews().firstWithName("Builds")
  assertElementPresent(build_list.cells())
  build_list


whenITapTheFirstBuild = (build_list) ->
  build_cell = build_list.cells()[0]
  assertElementPresent(build_cell, "build_cell")
  build_cell.tap()

thenIShouldSeeTheListOfJobs = (window) ->
  job_list = window.tableViews().firstWithName("Jobs")
  assertElementPresent(job_list.cells(), "job list cells()")
  job_list

whenITapTheFirstJob = (job_list) ->
  job_cell = job_list.cells()[0]
  assertElementPresent(job_list.cells(), "first job cell")
  job_cell.tap()

thenIShouldSeeJobDetailView = (window) ->
  job_detail = window.tableViews().firstWithName("Job Detail")
  assertElementPresent(job_detail.cells(), "job detail cells")
  job_detail

whenITapJobLog = (job_detail) ->
  log_cell = job_detail.cells().firstWithName("Logs")
  assertElementPresent(log_cell, "log_cell")
  log_cell.tap()

thenIShouldSeeTheJobLogFullscreen = (window) ->
  job_log_nav = window.elements().firstWithName("Job Log")
  assertElementPresent(job_log_nav, "Job Log Navigation Bar")

whenITapTheSecondRepo = (repository_list) ->
  latest_repo = repository_list.cells()[1]
  latest_repo.tap()

thenIShouldSeeJobLogFullscreen = (window, first_log_line) ->
  log = window.textViews()[0]
  if log.value() == first_log_line
    UIALogger.logPass("log displayed correctly")
  else
    UIALogger.logFail("log is not correct")
  log

thenIShouldSeeTheUpdatedLiveJobLog = (log, first_log_line, new_log_line) ->
  expected = (first_log_line + new_log_line)
  if log.value() == expected
    UIALogger.logPass("Live log displayed correctly")
  else
    UIALogger.logFail("Live log is not correct, expected: #{expected} got: #{log.value()}")

whenITapTheBackButton = (window) ->
  window.navigationBar().leftButton().tap()


target = UIATarget.localTarget()
window = target.frontMostApp().mainWindow()

repo_list = givenISeeRepositoryList(window)
whenITapTheFirstRepo(repo_list)
build_list = thenIShouldSeeTheListOfBuilds(window)
whenITapTheFirstBuild(build_list)
job_list = thenIShouldSeeTheListOfJobs(window)
whenITapTheFirstJob(job_list)
job_detail = thenIShouldSeeJobDetailView(window)
whenITapJobLog(job_detail)
thenIShouldSeeTheJobLogFullscreen(window)
first_log_line = "log line one\n"
log =         thenIShouldSeeJobLogFullscreen(window, first_log_line)

new_log_line =  "log line 2"
whenPusherSendsAnUpdateAboutThatJob(target, "110", new_log_line)
thenIShouldSeeTheUpdatedLiveJobLog(log, first_log_line, new_log_line)

# go back and re-enter job-detail
whenITapTheBackButton(window); # job log -> job detail
whenITapTheBackButton(window); # job detail -> job list
job_list = thenIShouldSeeTheListOfJobs(window)
whenITapTheFirstJob(job_list)
job_detail = thenIShouldSeeJobDetailView(window)
whenITapJobLog(job_detail)
thenIShouldSeeTheJobLogFullscreen(window)
current_log = first_log_line + new_log_line
log =         thenIShouldSeeJobLogFullscreen(window, current_log)
new_log_line =  "log line 3"
whenPusherSendsAnUpdateAboutThatJob(target, "110", new_log_line)
thenIShouldSeeTheUpdatedLiveJobLog(log, current_log, new_log_line)


whenITapTheBackButton(window); # job log -> job detail
whenITapTheBackButton(window); # job detail -> job list
whenITapTheBackButton(window); # job list -> build list
whenITapTheBackButton(window); # build list -> repo list

# second repo
repo_list =   givenISeeRepositoryList(window)
whenITapTheSecondRepo(repo_list)
build_list =  thenIShouldSeeTheListOfBuilds(window)
whenITapTheFirstBuild(build_list)
job_list =    thenIShouldSeeTheListOfJobs(window)
whenITapTheFirstJob(job_list)
job_detail =  thenIShouldSeeJobDetailView(window)
whenITapJobLog(job_detail)
first_log_line = "first log line\n"
log =         thenIShouldSeeJobLogFullscreen(window, first_log_line)
new_log_line =  "z second log line"
whenPusherSendsAnUpdateAboutThatJob(target, "210", new_log_line)
thenIShouldSeeTheUpdatedLiveJobLog(log, first_log_line, new_log_line)

