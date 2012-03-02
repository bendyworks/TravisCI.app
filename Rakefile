require 'open3'
require 'colorful'

task :clean do
  print 'Removing instrumentscli*.trace & automation/results/* ... '
  system 'rm -rf instrumentscli*.trace automation/results/*'
  puts 'done.'
end

task :coffeescript do
  test_files = 'automation/uiautomation.coffee'
  js_file = 'automation/uiautomation.js'
  system "coffee -b -p #{test_files} > #{js_file}"
end

task :build do
  workspace = '~/dev/ios/TravisCI/TravisCI.xcworkspace'
  scheme = 'TravisCI'
  configuration = 'Debug'
  sdk = 'iphonesimulator5.0'
  variables = {
    'TARGETED_DEVICE_FAMILY' => 1,
    'CONFIGURATION_BUILD_DIR' => '~/dev/ios/TravisCI/build'
  }.map{|key,val| "#{key}=#{val}"}.join(' ')

  system "xcodebuild \
    -workspace #{workspace} \
    -scheme #{scheme} \
    -configuration #{configuration} \
    -sdk #{sdk} \
    #{variables} \
    clean build"
end

task :test => :coffeescript do
  template = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate'
  app = '~/dev/ios/TravisCI/build/TravisCI.app'
  variables = {
    'UIASCRIPT' => '~/dev/ios/TravisCI/automation/uiautomation.js',
    'UIARESULTSPATH' => '~/dev/ios/TravisCI/automation/results'
  }.map{|key,val| "-e #{key} #{val}"}.join(' ')

  stdout_str, status = Open3.capture2("instruments -t #{template} #{app} #{variables}")

  stdout_str.each_line do |line|
    if line =~ /^\d{4}/
      tokens = line.split(' ')
      tokens.delete_at(2)
      tokens.delete_at(0)
      tokens[1] = tokens[1] =~ /Pass/ ? tokens[1].green : (tokens[1] =~ /Fail/ ? tokens[1].red : tokens[1].yellow)
      puts "#{tokens[0]} #{tokens[1]}\t#{tokens[2..-1].join(' ')}"
    else
      puts line
    end
  end
  status.success?
end

task :default => [:build, :test]
