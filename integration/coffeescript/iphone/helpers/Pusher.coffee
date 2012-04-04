class PusherClass
  appendToLog: (target, jobId, logText) ->
    path = "~/dev/ios/TravisCI/integration/pusher_event_log"
    args = [
      jobId
      logText
    ]
    host = UIATarget.localTarget().host()
    path = "~/dev/ios/TravisCI/integration/pusher_event"
    timeout = 5 # seconds

    host.performTaskWithPathArgumentsTimeout(path, args, timeout)


Pusher = new PusherClass
