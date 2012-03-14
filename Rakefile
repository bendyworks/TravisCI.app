require 'open3'
require 'colorful'

task :clean do
  print 'Removing instrumentscli*.trace & automation/results/* ... '
  system 'rm -rf instrumentscli*.trace automation/results/*'
  puts 'done.'
end

task :clean_db do
  print 'Cleaning the applications sqlite cache database'
  system 'rm -rf ls -1d ~/Library/Application\ Support/iPhone\ Simulator/**/Applications/**/Library/Caches/TravisCI*.sqlite'
end

task :coffeescript do
  test_files = 'automation/*.coffee'
  system "coffee -b -c #{test_files}"
end

task :build do
  @current_build ||=1
  workspace = '~/dev/ios/TravisCI/TravisCI.xcworkspace'
  scheme = 'TravisCI'
  configuration = 'Debug'
  sdk = 'iphonesimulator5.0'
  variables = {
    'TARGETED_DEVICE_FAMILY' => @current_build,
    'GCC_PREPROCESSOR_DEFINITIONS' => 'TEST_MODE=1',
    'CONFIGURATION_BUILD_DIR' => '~/dev/ios/TravisCI/build'
  }.map{|key,val| "#{key}=#{val}"}.join(' ')

  exited_with_0 = system "xcodebuild \
    -workspace #{workspace} \
    -scheme #{scheme} \
    -configuration #{configuration} \
    -sdk #{sdk} \
    #{variables} \
    clean build"

  raise 'Build failed' unless exited_with_0
end

def run_test_with_script path
  project_dir = Dir.pwd
  template = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate'
  app = File.join(project_dir, 'build', 'TravisCI.app')
  variables = {
    'UIASCRIPT' => File.join(project_dir, 'automation', path),
    'UIARESULTSPATH' => File.join(project_dir, 'automation', 'results')
  }.map{|key,val| "-e #{key} #{val}"}.join(' ')

  cmd = "instruments -t #{template} #{app} #{variables}"

  stdout_str, status = Open3.capture2(cmd)

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
end

task :ipad do
  Rake::Task['ipad:build'].execute
  Rake::Task['ipad:test'].execute
end

namespace :ipad do
  task :build do
    @current_build = 2
    Rake::Task['clean_db'].execute
    Rake::Task['build'].execute
  end

  task :test => :coffeescript do
    run_test_with_script 'ipad.js'
  end
end

task :iphone do
  Rake::Task['iphone:build'].execute
  Rake::Task['iphone:test'].execute
end

namespace :iphone do
  task :build do
    @current_build = 1
    Rake::Task['clean_db'].execute
    Rake::Task['build'].execute
  end

  task :test => :coffeescript do
    run_test_with_script 'iphone.js'
  end
end

task :test => :coffeescript do
  Rake::Task['iphone'].execute
  Rake::Task['ipad'].execute
end

task :default => :test
