
function assertElementPresent(el, el_name) {
  el_name = el_name ? el_name : '';
  if (el.isValid()) {
    return UIALogger.logPass("Element " + el_name + " is present");
  } else {
    return UIALogger.logFail("Element " + el_name + " is not present");
  }
}

function whenPusherSendsAnUpdateAboutThatJob(target, job_id, new_log_line) {
  var path = "/Users/bendyworks/dev/ios/TravisCI/automation/pusher_event"
  var args = [("job-" + job_id), "job:log", '{"id":' + job_id + ',"_log":"' + new_log_line + '"}'];
  var timeout = 5; // seconds
  var host = target.host();
  var result = host.performTaskWithPathArgumentsTimeout(path, args, timeout);

  if (result.exitCode == 0) {
    UIALogger.logPass("Pusher Scripted Called");
  } else {
    UIALogger.logPass("Pusher Script had an error: " + result.stderr + result.stdout);
  }
}


function givenISeeRepositoryList(window) {
  var repository_list = window.tableViews().firstWithName("Repositories");
  assertElementPresent(repository_list.cells(), "repository cells");
  return repository_list;
}

function whenITapTheFirstRepo(repository_list) {
  var latest_repo = repository_list.cells()[0];
  latest_repo.tap();
}

function thenIShouldSeeTheListOfBuilds(window) {
  var build_list = window.tableViews().firstWithName("Builds");
  assertElementPresent(build_list.cells());
  return build_list;
}


function whenITapTheFirstBuild(build_list) {
  var build_cell = build_list.cells()[0];
  assertElementPresent(build_cell, "build_cell");
  build_cell.tap();
}

function thenIShouldSeeTheListOfJobs(window) {
  var job_list = window.tableViews().firstWithName("Jobs");
  assertElementPresent(job_list.cells(), "job list cells()");
  return job_list;
}

function whenITapTheFirstJob(job_list) {
  var job_cell = job_list.cells()[0];
  assertElementPresent(job_list.cells(), "first job cell");
  job_cell.tap();
}

function thenIShouldSeeJobDetailView(window) {
  var job_detail = window.tableViews().firstWithName("Job Detail");
  assertElementPresent(job_detail.cells(), "job detail cells");
  return job_detail;
}

function whenITapJobLog(job_detail) {
  var log_cell = job_detail.cells().firstWithName("Logs");
  assertElementPresent(log_cell, "log_cell");
  log_cell.tap();
}

function thenIShouldSeeTheJobLogFullscreen(window) {
  var job_log_nav = window.elements().firstWithName("Job Log");
  assertElementPresent(job_log_nav, "Job Log Navigation Bar");
}

function whenITapTheSecondRepo(repository_list) {
  var latest_repo = repository_list.cells()[1];
  latest_repo.tap();
}

function thenIShouldSeeJobLogFullscreen(window, first_log_line) {
  var log = window.textViews()[0];
  if (log.value() === first_log_line) {
    UIALogger.logPass("log displayed correctly");
  } else {
    UIALogger.logFail("log is not correct");
  }
  return log;
}

function thenIShouldSeeTheUpdatedLiveJobLog(log, first_log_line, new_log_line) {
  if (log.value() === first_log_line + new_log_line) {
    UIALogger.logPass("live log displayed correctly");
  } else {
    UIALogger.logFail("live log is not correct");
  }
}

function whenITapTheBackButton(window) {
  window.navigationBar().leftButton().tap();
}


var target = UIATarget.localTarget();
var window = target.frontMostApp().mainWindow();

var repo_list =   givenISeeRepositoryList(window);
          whenITapTheFirstRepo(repo_list);
var build_list =  thenIShouldSeeTheListOfBuilds(window);
          whenITapTheFirstBuild(build_list);
var job_list =    thenIShouldSeeTheListOfJobs(window);
          whenITapTheFirstJob(job_list);
var job_detail =  thenIShouldSeeJobDetailView(window);
          whenITapJobLog(job_detail);
          thenIShouldSeeTheJobLogFullscreen(window);
var first_log_line = "log line one\n";
var log =     thenIShouldSeeJobLogFullscreen(window, first_log_line);

var new_log_line =  "log line 2";
          whenPusherSendsAnUpdateAboutThatJob(target, "110", new_log_line);
          thenIShouldSeeTheUpdatedLiveJobLog(log, first_log_line, new_log_line);  

          whenITapTheBackButton(window); // job log -> job detail
          whenITapTheBackButton(window); // job detail -> job list
          whenITapTheBackButton(window); // job list -> build list
          whenITapTheBackButton(window); // build list -> repo list

// second repo
repo_list =   givenISeeRepositoryList(window);
        whenITapTheSecondRepo(repo_list);
build_list =  thenIShouldSeeTheListOfBuilds(window);
        whenITapTheFirstBuild(build_list);
job_list =    thenIShouldSeeTheListOfJobs(window);
        whenITapTheFirstJob(job_list);
job_detail =  thenIShouldSeeJobDetailView(window);
        whenITapJobLog(job_detail);
first_log_line = "first log line\n";
log =     thenIShouldSeeJobLogFullscreen(window, first_log_line);
new_log_line =  "z second log line";
        whenPusherSendsAnUpdateAboutThatJob(target, "210", new_log_line);
        thenIShouldSeeTheUpdatedLiveJobLog(log, first_log_line, new_log_line);

