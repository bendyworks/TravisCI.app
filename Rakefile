require 'open3'
require 'colorful'

task :clean do
  print 'Removing instrumentscli*.trace & automation/results/* ... '
  system 'rm -rf instrumentscli*.trace automation/results/*'
  puts 'done.'
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

  system "xcodebuild \
    -workspace #{workspace} \
    -scheme #{scheme} \
    -configuration #{configuration} \
    -sdk #{sdk} \
    #{variables} \
    clean build"
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

task :build_for_ipad do
  @current_build = 2
  Rake::Task['build'].execute
end

task :build_for_iphone do
  @current_build = 1
  Rake::Task['build'].execute
end

task :test_ipad => :coffeescript do
  run_test_with_script 'ipad.js'
end

task :test_iphone => :coffeescript do
  run_test_with_script 'iphone.js'
end

task :test => :coffeescript do
  run_test_with_script 'iphone.js'
end

task :default => [:build_for_iphone, :test_iphone]
