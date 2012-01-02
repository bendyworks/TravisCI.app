// use this bookmarklet on pusher's event creator page:
// app.pusherapp.com/apps/<id>/event_creator
// <a href="javascript:(function(){script_tag=document.createElement('SCRIPT');script_tag.type='text/javascript';script_tag.src='https://github.com/bendyworks/TravisCI.app/raw/master/doc/pusher_events.js';document.getElementsByTagName('head')[0].appendChild(script_tag);})();">TravisCI - Pusher events</a>

var bw_event_hash = {
  "job:started" : '{'
    + '"build_id": 468459,'
    + '"id": 468460,'
    + '"started_at": "2012-01-02T15:30:00Z",'
    + '"state": "started"'
    + '}'
  ,

  "job:created" : '{'
    + '"build_id":468459,'
    + '"id":468460,'
    + '"number":"11.1",'
    + '"queue":"builds.node_js",'
    + '"repository_id":5098,'
    + '"started_at":"2012-01-02T15:30:00Z",'
    + '"state":"started"'
    + '}'
  ,

  "job:finished" : '{'
    + '"build_id": 468459,'
    + '"finished_at": "2012-01-02T15:33:40Z",'
    + '"id": 468460,'
    + '"result": 0,'
    + '"state": "finished",'
    + '"status": 0'
    + '}'
  ,

  "build:started" : '{'
    + '"build": {'
        + '"author_email": "henri.bergius@iki.fi",'
        + '"author_name": "Henri Bergius",'
        + '"branch": "master",'
        + '"commit": "2a311c24ff1813595d071e1b310548bf18a9f729",'
        + '"committed_at": "2012-01-02T15:30:14Z",'
        + '"committer_email": null,'
        + '"committer_name": null,'
        + '"compare_url": "https://github.com/bergie/create/compare/749ae09...2a311c2",'
        + '"config": {'
          + '"id": 468459,'
          + '".configured": true,'
          + '"before_script": ['
            + '"npm install --dev"'
          + '],'
          + '"language": "node_js",'
          + '"node_js": ['
            + '0.6'
          + '],'
          + '"notifications": {'
            + '"irc": ['
              + '"irc.freenode.org#iks",'
              + '"irc.freenode.org#midgard"'
            + '],'
            + '"script": "npm test"'
          + '}'
        + '},'
        + '"matrix": ['
          + '{'
            + '"id": 468460,'
            + '"author_email": "henri.bergius@iki.fi",'
            + '"author_name": "Henri Bergius",'
            + '"branch": "master",'
            + '"commit": "2a311c24ff1813595d071e1b310548bf18a9f729",'
            + '"committed_at": "2012-01-02T15:30:14Z",'
            + '"committer_email": null,'
            + '"committer_name": null,'
            + '"compare_url": "https://github.com/bergie/create/compare/749ae09...2a311c2",'
            + '"config": {'
              + '".configured": true,'
              + '"before_script": ['
                + '"npm install --dev"'
                + '],'
              + '"language": "node_js",'
              + '"node_js": 0.6,'
              + '"notifications": {'
                + '"irc": ['
                  + '"irc.freenode.org#iks",'
                  + '"irc.freenode.org#midgard"'
                  + ']'
                + '},'
              + '"script": "npm test"'
            + '},'
            + '"message": "Update to latest VIE, refs #18",'
            + '"number": "11.1",'
            + '"parent_id": 468459,'
            + '"repository_id": 5098,'
            + '"started_at": "2012-01-02T15:30:00Z"'
          + '}'
        + '],'
        + '"message": "Update to latest VIE, refs #18",'
        + '"number": "11",'
        + '"repository_id": 5098,'
        + '"result": null,'
        + '"started_at": "2012-01-02T15:30:00Z"'
      + '},'
      + '"repository": {'
        + '"description": "Midgard Create, a generic web editing interface for any CMS",'
        + '"id": 5098,'
        + '"last_build_duration": null,'
        + '"last_build_finished_at": null,'
        + '"last_build_id": 468459,'
        + '"last_build_language": null,'
        + '"last_build_number": "11",'
        + '"last_build_result": null,'
        + '"last_build_started_at": "2012-01-02T15:30:00Z",'
        + '"slug": "bergie/create"'
        + '},'
      + '"started_at": "2012-01-02T15:30:00Z"'
    + '}'
  ,

  "build:finished": '{'
    + '"finished_at": "2012-01-02T15:33:40Z",'
    + '"status": 0,'
    + '"build": {'
      + '"id": 468459,'
      + '"finished_at": "2012-01-02T15:33:40Z",'
      + '"result": 0'
    + '},'
    + '"repository": {'
      + '"id": 5098,'
      + '"last_build_duration": 220,'
      + '"last_build_finished_at": "2012-01-02T15:33:40Z",'
      + '"last_build_id": 468459,'
      + '"last_build_number": "11",'
      + '"last_build_result": 0,'
      + '"last_build_started_at": "2012-01-02T15:30:00Z",'
      + '"slug": "bergie/create"'
    + '}'
  + '}'
}

jQuery('ul.nav:first').append(jQuery('<li class="pulldown"><a href="#" class="icon pulldown"><span>TravisCI</span></a><ul id="bw_event_list"></ul></li>'));

var bw_append_event = function(event_name, json_string) {
  var safe_name = event_name.replace(":","_");
  jQuery('#bw_event_list').append('<li><a id="bw_event_' + safe_name + '" href="#">' + event_name + '</a></li>');
  jQuery('#bw_event_' + safe_name).click(function(){
    jQuery('#event_channel').val('common');
    jQuery('#event_event_name').val(event_name);
    jQuery('#event_data').val(json_string);
    jQuery('#event_creator').submit();
  });
}

for (event_name in bw_event_hash) {
  bw_append_event(event_name, bw_event_hash[event_name]);
}
