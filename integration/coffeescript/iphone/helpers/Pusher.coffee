class PusherClass
  appendToLog: (jobId, logText) ->
    path = "~/dev/ios/TravisCI/integration/pusher_event_log"
    args = [
      jobId
      logText
    ]
    host = UIATarget.localTarget().host()
    timeout = 5 # seconds

    host.performTaskWithPathArgumentsTimeout(path, args, timeout)


Pusher = new PusherClass
