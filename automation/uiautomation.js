var assertElementPresent, build_list, first_log_line, givenISeeRepositoryList, job_detail, job_list, log, new_log_line, repo_list, target, thenIShouldSeeJobDetailView, thenIShouldSeeJobLogFullscreen, thenIShouldSeeTheJobLogFullscreen, thenIShouldSeeTheListOfBuilds, thenIShouldSeeTheListOfJobs, thenIShouldSeeTheUpdatedLiveJobLog, whenITapJobLog, whenITapTheBackButton, whenITapTheFirstBuild, whenITapTheFirstJob, whenITapTheFirstRepo, whenITapTheSecondRepo, whenPusherSendsAnUpdateAboutThatJob, window;

assertElementPresent = function(el, el_name) {
  el_name = el_name != null ? el_name : {
    el_name: ''
  };
  if (el.isValid()) {
    return UIALogger.logPass("Element " + el_name + " is present");
  } else {
    return UIALogger.logFail("Element " + el_name + " is not present");
  }
};

whenPusherSendsAnUpdateAboutThatJob = function(target, job_id, new_log_line) {
  var args, host, path, result, timeout;
  path = "/Users/bendyworks/dev/ios/TravisCI/automation/pusher_event";
  args = ["job-" + job_id, "job:log", "{\"id\" : " + job_id + ", \"_log\" : \"" + new_log_line + "\"}"];
  timeout = 5;
  host = target.host();
  result = host.performTaskWithPathArgumentsTimeout(path, args, timeout);
  if (result.exitCode === 0) {
    return UIALogger.logPass("Pusher Scripted Called");
  } else {
    return UIALogger.logPass("Pusher Script had an error: " + result.stderr + " " + result.stdout);
  }
};

givenISeeRepositoryList = function(window) {
  var repository_list;
  repository_list = window.tableViews().firstWithName("Repositories");
  assertElementPresent(repository_list.cells(), "repository cells");
  return repository_list;
};

whenITapTheFirstRepo = function(repository_list) {
  var latest_repo;
  latest_repo = repository_list.cells()[0];
  return latest_repo.tap();
};

thenIShouldSeeTheListOfBuilds = function(window) {
  var build_list;
  build_list = window.tableViews().firstWithName("Builds");
  assertElementPresent(build_list.cells());
  return build_list;
};

whenITapTheFirstBuild = function(build_list) {
  var build_cell;
  build_cell = build_list.cells()[0];
  assertElementPresent(build_cell, "build_cell");
  return build_cell.tap();
};

thenIShouldSeeTheListOfJobs = function(window) {
  var job_list;
  job_list = window.tableViews().firstWithName("Jobs");
  assertElementPresent(job_list.cells(), "job list cells()");
  return job_list;
};

whenITapTheFirstJob = function(job_list) {
  var job_cell;
  job_cell = job_list.cells()[0];
  assertElementPresent(job_list.cells(), "first job cell");
  return job_cell.tap();
};

thenIShouldSeeJobDetailView = function(window) {
  var job_detail;
  job_detail = window.tableViews().firstWithName("Job Detail");
  assertElementPresent(job_detail.cells(), "job detail cells");
  return job_detail;
};

whenITapJobLog = function(job_detail) {
  var log_cell;
  log_cell = job_detail.cells().firstWithName("Logs");
  assertElementPresent(log_cell, "log_cell");
  return log_cell.tap();
};

thenIShouldSeeTheJobLogFullscreen = function(window) {
  var job_log_nav;
  job_log_nav = window.elements().firstWithName("Job Log");
  return assertElementPresent(job_log_nav, "Job Log Navigation Bar");
};

whenITapTheSecondRepo = function(repository_list) {
  var latest_repo;
  latest_repo = repository_list.cells()[1];
  return latest_repo.tap();
};

thenIShouldSeeJobLogFullscreen = function(window, first_log_line) {
  var log;
  log = window.textViews()[0];
  if (log.value() === first_log_line) {
    UIALogger.logPass("log displayed correctly");
  } else {
    UIALogger.logFail("log is not correct");
  }
  return log;
};

thenIShouldSeeTheUpdatedLiveJobLog = function(log, first_log_line, new_log_line) {
  var expected;
  expected = first_log_line + new_log_line;
  if (log.value() === expected) {
    return UIALogger.logPass("Live log displayed correctly");
  } else {
    return UIALogger.logFail("Live log is not correct, expected: " + expected + " got: " + (log.value()));
  }
};

whenITapTheBackButton = function(window) {
  return window.navigationBar().leftButton().tap();
};

target = UIATarget.localTarget();

window = target.frontMostApp().mainWindow();

repo_list = givenISeeRepositoryList(window);

whenITapTheFirstRepo(repo_list);

build_list = thenIShouldSeeTheListOfBuilds(window);

whenITapTheFirstBuild(build_list);

job_list = thenIShouldSeeTheListOfJobs(window);

whenITapTheFirstJob(job_list);

job_detail = thenIShouldSeeJobDetailView(window);

whenITapJobLog(job_detail);

thenIShouldSeeTheJobLogFullscreen(window);

first_log_line = "log line one\n";

log = thenIShouldSeeJobLogFullscreen(window, first_log_line);

new_log_line = "pushed log line";

whenPusherSendsAnUpdateAboutThatJob(target, "110", new_log_line);

thenIShouldSeeTheUpdatedLiveJobLog(log, first_log_line, new_log_line);

whenITapTheBackButton(window);

whenITapTheBackButton(window);

job_list = thenIShouldSeeTheListOfJobs(window);

whenITapTheFirstJob(job_list);

job_detail = thenIShouldSeeJobDetailView(window);

whenITapJobLog(job_detail);

thenIShouldSeeTheJobLogFullscreen(window);

log = thenIShouldSeeJobLogFullscreen(window, first_log_line);

new_log_line = "Another pushed log line";

whenPusherSendsAnUpdateAboutThatJob(target, "110", new_log_line);

thenIShouldSeeTheUpdatedLiveJobLog(log, first_log_line, new_log_line);

whenITapTheBackButton(window);

whenITapTheBackButton(window);

whenITapTheBackButton(window);

whenITapTheBackButton(window);

repo_list = givenISeeRepositoryList(window);

whenITapTheSecondRepo(repo_list);

build_list = thenIShouldSeeTheListOfBuilds(window);

whenITapTheFirstBuild(build_list);

job_list = thenIShouldSeeTheListOfJobs(window);

whenITapTheFirstJob(job_list);

job_detail = thenIShouldSeeJobDetailView(window);

whenITapJobLog(job_detail);

first_log_line = "first log line\n";

log = thenIShouldSeeJobLogFullscreen(window, first_log_line);

new_log_line = "z second log line";

whenPusherSendsAnUpdateAboutThatJob(target, "210", new_log_line);

thenIShouldSeeTheUpdatedLiveJobLog(log, first_log_line, new_log_line);
