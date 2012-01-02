
jQuery('ul.nav:first').append(jQuery('<li class="pulldown"><a href="#" class="icon pulldown"><span>TravisCI</span></a><ul id="bw_event_list"></ul></li>'));

// job:created
var bw_job_created_string = '{"build_id":468459,'
    + '"id":468460,'
    + '"number":"11.1",'
    + '"queue":"builds.node_js",'
    + '"repository_id":5098,'
    + '"started_at":"2012-01-02T15:30:00Z",'
    + '"state":"started"}'
    ;

jQuery('#bw_event_list').append('<li><a id="bw_event_job_created" href="#">job:created</a></li>');
jQuery('#bw_event_job_created').click(function(){
  jQuery('#event_channel').val('common');
  jQuery('#event_event_name').val('job:created');
  jQuery('#event_data').val(bw_job_created_string);
  jQuery('#event_creator').submit();
});

// job:started
var bw_job_started_string = '{'
  + '"build_id": 468459,'
  + '"id": 468460,'
  + '"started_at": "2012-01-02T15:30:00Z",'
  + '"state": "started"'
  + '}';

jQuery('#bw_event_list').append('<li><a id="bw_event_job_started" href="#">job:started</a></li>');
jQuery('#bw_event_job_started').click(function(){
  jQuery('#event_channel').val('common');
  jQuery('#event_event_name').val('job:started');
  jQuery('#event_data').val(bw_job_started_string);
  jQuery('#event_creator').submit();
});
