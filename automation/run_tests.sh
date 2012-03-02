#!/usr/bin/env bash

xcodebuild -workspace ~/dev/ios/TravisCI/TravisCI.xcworkspace -scheme TravisCI -configuration Debug -sdk iphonesimulator5.0 TARGETED_DEVICE_FAMILY=1 clean build
instruments -t /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate ~/Library/Developer/Xcode/DerivedData/TravisCI-*/Build/Products/Debug-iphonesimulator/TravisCI.app -e UIASCRIPT uiautomation.js -e UIARESULTSPATH results/

