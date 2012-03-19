require 'open3'
require 'colorful'

task :clean do
  print 'Removing instrumentscli*.trace & automation/results/* ... '
  system 'rm -rf instrumentscli*.trace automation/results/*'
  puts 'done.'
end

task :clean_db do
  puts "Cleaning the application's sqlite cache database"
  system 'rm -rf ls -1d ~/Library/Application\ Support/iPhone\ Simulator/**/Applications/**/Library/Caches/TravisCI*.sqlite'
end

task :coffeescript do
  test_files = 'automation/*.coffee'
  system "coffee -b -c #{test_files}"
end

task :build do
  @current_build ||=1
  build_device = @current_build == 1 ? "iphone" : "ipad"
  workspace = '~/dev/ios/TravisCI/TravisCI.xcworkspace'
  scheme = 'TravisCI'
  configuration = 'Debug'
  sdk = 'iphonesimulator5.0'
  variables = {
    'TARGETED_DEVICE_FAMILY' => @current_build,
    'GCC_PREPROCESSOR_DEFINITIONS' => 'TEST_MODE=1',
    'CONFIGURATION_BUILD_DIR' => '~/dev/ios/TravisCI/build'
  }.map{|key,val| "#{key}=#{val}"}.join(' ')

  cmd = "xcodebuild \
    -workspace #{workspace} \
    -scheme #{scheme} \
    -configuration #{configuration} \
    -sdk #{sdk} \
    #{variables} \
    clean build"

  stdin, stdout, stderr, wait_thr = Open3.popen3 cmd

  print "Building for #{build_device}"
  out_string = ""

  stdout.each_line do |line|
    out_string += line
    print "."
  end
  out_string += stderr.read

  stdin.close
  stdout.close
  stderr.close
  exit_status = wait_thr.value
  puts ""

  if exit_status == 0
    puts ""
    puts "## Build Successful ##"
    puts ""
  else
    puts out_string
    raise 'Build failed'
  end
end

def run_test_with_script path
  project_dir = Dir.pwd
  template = '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate'
  app = File.join(project_dir, 'build', 'TravisCI.app')
  results_path = File.join(project_dir, 'automation', 'results')
  variables = {
    'UIASCRIPT' => File.join(project_dir, 'automation', path),
    'UIARESULTSPATH' => results_path
  }.map{|key,val| "-e #{key} #{val}"}.join(' ')

  cmd = "mkdir -p #{results_path} && unix_instruments.sh -t #{template} #{app} #{variables}"

  Open3.popen2(cmd) {|stdin, stdout, wait_thr|
    stdout.each_line do |line|
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
  }

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
