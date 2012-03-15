TravisCI.app
============

Get it on the [App Store!](http://itunes.apple.com/us/app/travisci/id496877270)

screenshots
-----------

![iPad Screenshot](https://raw.github.com/bendyworks/TravisCI.app/master/doc/iPad_screenshot.png)

![iPhone Screenshot](https://raw.github.com/bendyworks/TravisCI.app/master/doc/iPhone_screenshot.png)


local setup
-----------

gem and pod setup:

`gem install bundler`

`bundle`

`pod install TravisCI.xcodeproj`


test
----

start the localport binding:

`./automation/http_tunnel.sh`

start the test travisci server:

`ruby automation/test_travis_server.rb`

test:

`rake`

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
