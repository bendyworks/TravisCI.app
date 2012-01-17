TravisCI.app
============

screenshots
-----------

![iPad Screenshot](https://raw.github.com/bendyworks/TravisCI.app/master/doc/iPad_screenshot.png)

![iPhone Screenshot](https://raw.github.com/bendyworks/TravisCI.app/master/doc/iPhone_screenshot.png)


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

deploy
---------

you can also check out http://support.testflightapp.com/kb/tutorials/how-to-create-an-ipa-xcode-3

* select iOS Device instead of simulator

* from Xcode click Product > Archive from the menu. When Xcode finishes you should see the organizer appear.

* Select the resulting build, and click 'Share...'

* Choose 'iOS App Store Package (.ipa)' from 'Contents:'

* Select the ad-hoc profile that is set up with testflightapp.com 'TravisCI ad hoc' from 'Identity:' and click next

* Save the ipa somewhere that makes sense

* upload to testflightapp.com


Adding a new device to test with the app
----------------------------------------

* sign up the user with testflightapp.com

* once they register with a device retrieve their device's UUID from testflightapp.com

* Register their device in our apple development portal.

* In our apple development portal under Provisioning > Distribution Edit > Modify the ad-hoc profile

* Select the newly regestered device and press Submit

* Wait for apple (refresh the page after ~30 seconds upto 2 minutes)

* Download the new profile

* In the organizer delete the current ad-hoc profile

* open the newly downloaded ad-hoc profile

* your all set!
