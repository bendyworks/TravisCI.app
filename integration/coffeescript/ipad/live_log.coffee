#import "../../../../Pods/tuneup_js/tuneup.js"

#import "helpers/TravisCI.js"

test 'see list of builds', (target, app) ->
  RepositoriesScreen.reveal()
  RepositoriesScreen.tapRepositoryNamed 'CITravis by Travis-ci'
  BuildsScreen.assertInView()

test 'see list of jobs', (target, app) ->
  BuildsScreen.tapBuildNumber 3
  JobsScreen.assertInView()

test 'see job detail', (target, app) ->
  JobsScreen.tapJobNumber '3.1'
  JobDetailScreen.assertInView()

test 'see job log', (target, app) ->
  JobDetailScreen.assertLogEquals("log line one\n")

test 'pusher works with job log', (target, app) ->
  Pusher.appendToLog("110", "pushed log line\n")
  JobDetailScreen.assertLogEquals("log line one\npushed log line\n")
