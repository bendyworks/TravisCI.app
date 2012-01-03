TravisCI.app
============

local setup
-----------

To run in a developement environment:

* run travis-ci locally

`git clone git://github.com/travis-ci/travis-ci.git`

`cd travis-ci`

add a rvmrc file

`bundle`

`bundle exec rake travis:setup:config`

`bundle exec rake travis:setup`

`bundle exec foreman start`

* bind localhost:80 to 5000

`sudo ssh -L 80:localhost:5000 localhost`

* tell TravisCI.app not to use actual travis data

`USE_ACTUAL_TRAVIS_CI_DATA 0`

* tell TravisCI.app not to use actual pusher data

`USE_ACTUAL_TRAVIS_CI_PUSHER_DATA 0`
