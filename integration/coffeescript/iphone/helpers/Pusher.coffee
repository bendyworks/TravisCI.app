class PusherClass
  appendToLog: (jobId, logText) ->
    args = [
      "job-#{jobId}"
      "job:log"
      """{"id" : #{jobId}, "_log" : "#{logText}"}"""
    ]
    host = UIATarget.localTarget().host()
    path = "~/dev/ios/TravisCI/integration/pusher_event"
    timeout = 5 # seconds
    UIALogger.logDebug("host: #{host}")

    result = host.performTaskWithPathArgumentsTimeout(path, args, timeout)
    UIALogger.logDebug("exitCode: " + result.exitCode)
    UIALogger.logDebug("stdout: " + result.stdout)
    UIALogger.logDebug("stderr: " + result.stderr)


Pusher = new PusherClass
