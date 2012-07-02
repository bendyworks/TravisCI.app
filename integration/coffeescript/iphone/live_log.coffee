#import "../../../../Pods/tuneup_js/tuneup.js"

#import "helpers/TravisCI.js"

test 'see list of builds', (target, app) ->
  RepositoriesScreen.tapRepositoryNamed 'CITravis by Travis-ci'
  BuildsScreen.assertInView()

test 'see list of jobs', (target, app) ->
  BuildsScreen.tapBuildNumber 3
  JobsScreen.assertInView()

test 'see job detail', (target, app) ->
  JobsScreen.tapJobNumber '3.1'
  JobDetailScreen.assertInView()

test 'see job log', (target, app) ->
  JobDetailScreen.tapLog()
  JobLogScreen.assertInView()
  JobLogScreen.assertLogEquals("log line one\n")

test 'pusher works with job log', (target, app) ->
  Pusher.appendToLog("110", "pushed log line\n")
  JobLogScreen.assertLogEquals("log line one\npushed log line\n")

test 'going back and re-entering log still updates', (target, app) ->
  JobLogScreen.back()
  JobDetailScreen.back()
  JobsScreen.tapJobNumber '3.1'
  JobDetailScreen.tapLog()
  Pusher.appendToLog("110", "another line\n")

  # NOTE: Because Pusher & sinatra are not synced during tests, the first
  # pushed log line will not appear:
  #
  # JobLogScreen.assertLogEquals("log line one\npushed log line\nanother line\n")
  #
  # Instead, we just care (for the regression's sake) that the log got updated
  # a second time
  JobLogScreen.assertLogEquals("log line one\npushed log line\nanother line\n")


# 
# whenITapTheBackButton(window); # job log -> job detail
# whenITapTheBackButton(window); # job detail -> job list
# whenITapTheBackButton(window); # job list -> build list
# whenITapTheBackButton(window); # build list -> repo list
# 
# # second repo
# repo_list =   givenISeeRepositoryList(window)
# whenITapTheSecondRepo(repo_list)
# build_list =  thenIShouldSeeTheListOfBuilds(window)
# whenITapTheFirstBuild(build_list)
# job_list =    thenIShouldSeeTheListOfJobs(window)
# whenITapTheFirstJob(job_list)
# job_detail =  thenIShouldSeeJobDetailView(window)
# whenITapJobLog(job_detail)
# first_log_line = "first log line\n"
# log =         thenIShouldSeeJobLogFullscreen(window, first_log_line)
# new_log_line =  "z second log line"
# whenPusherSendsAnUpdateAboutThatJob(target, "210", new_log_line)
# thenIShouldSeeTheUpdatedLiveJobLog(log, first_log_line, new_log_line)
# 
