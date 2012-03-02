#!/usr/bin/env bash

xcodebuild -workspace ~/dev/ios/TravisCI/TravisCI.xcworkspace -scheme TravisCI -configuration Debug -sdk iphonesimulator5.0 TARGETED_DEVICE_FAMILY=1 CONFIGURATION_BUILD_DIR=~/dev/ios/TravisCI/build clean build
instruments -t /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate ~/dev/ios/TravisCI/build/TravisCI.app -e UIASCRIPT ~/dev/ios/TravisCI/automation/uiautomation.js -e UIARESULTSPATH ~/dev/ios/TravisCI/automation/results

