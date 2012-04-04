class PusherClass
  appendToLog: (target, jobId, logText) ->
    path = "~/dev/ios/TravisCI/integration/pusher_event_log"
    args = [
      jobId
      logText
    ]
    timeout = 5 # seconds
    host = target.host()
    host.performTaskWithPathArgumentsTimeout(path, args, timeout)

Pusher = new PusherClass
