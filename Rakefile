require 'open3'
require 'colorful'


def app_name
  File.basename(project_directory)
end

def project_directory
  Dir.pwd
end

def path_to_automation
  '/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/Library/Instruments/PlugIns/AutomationInstrument.bundle/Contents/Resources/Automation.tracetemplate'
end

def build_directory
  Dir.mkdir('build') unless Dir.exists?('build')
  File.join(project_directory, 'build')
end

def app
  File.join(build_directory, "#{app_name}.app")
end

def workspace
  File.join(project_directory, "#{app_name}.xcworkspace")
end

desc 'Remove result and trace files'
task :clean do
  print 'Removing instrumentscli*.trace & automation/results/* ... '
  system 'rm -rf instrumentscli*.trace automation/results/*'
  puts 'done.'
end

# task :clean_db do
  # puts "Cleaning the application's sqlite cache database"
  # system 'rm -rf ls -1d ~/Library/Application\ Support/iPhone\ Simulator/**/Applications/**/Library/Caches/TravisCI*.sqlite'
# end

desc 'Compile the workspace'
task :build do

  scheme = app_name
  configuration = 'Debug'
  sdk = 'iphonesimulator5.1'
  variables = {
    'GCC_PREPROCESSOR_DEFINITIONS' => 'TEST_MODE=1',
    'CONFIGURATION_BUILD_DIR' => build_directory
  }.map{|key,val| "#{key}=#{val}"}.join(' ')

  cmd = "xcodebuild \
    -workspace #{workspace} \
    -scheme #{scheme} \
    -configuration #{configuration} \
    -sdk #{sdk} \
    #{variables} \
    clean build"

  Open3.popen2e(cmd) do |stdin, stdout, wait_thr|

    print "Building"
    out_string = ""

    stdout.each_line do |line|
      out_string << line
      print "."
    end

    exit_status = wait_thr.value
    puts

    if exit_status == 0
      puts
      puts "## Build Successful ##"
      puts
    else
      puts out_string
      raise 'Build failed'
    end
  end
end

def results_path
  File.join(project_directory, 'automation', 'results').tap do |dir_name|
    Dir.mkdir_p(dir_name) unless Dir.exists?(dir_name)
  end
end

def set_simulator_to_run device_family
  device_family_id = device_family == 'iphone' ? 1 : 2
  plistbuddy = '/usr/libexec/PlistBuddy'
  plist_file = "#{app}/Info.plist"
  system "#{plistbuddy} -c 'Delete :UIDeviceFamily' #{plist_file}"
  system "#{plistbuddy} -c 'Add :UIDeviceFamily array' #{plist_file}"
  system "#{plistbuddy} -c 'Add :UIDeviceFamily:0 integer #{device_family_id}' #{plist_file}"
end

def run_test_with_script path, device_family = nil
  device_family ||= ENV['FAMILY'] || 'iphone'

  set_simulator_to_run device_family

  variables = {
    'UIASCRIPT' => path,
    'UIARESULTSPATH' => results_path
  }.map{|key,val| "-e #{key} #{val}"}.join(' ')

  cmd = "mkdir -p #{results_path} && \
    unix_instruments.sh \
    -t #{path_to_automation} \
    #{app} \
    #{variables}"

  Open3.popen2e(cmd) do |stdin, stdout, wait_thr|
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
  end

end

task :coffeescript do
  test_files = 'automation/*.coffee'
  system "coffee -b -c #{test_files}"
end

device_families = %w(iphone ipad)

device_families.each do |device_family|
  namespace device_family do
    desc "Run tests for #{device_family}"
    task :test => :coffeescript do
      run_test_with_script "automation/#{device_family}.js", device_family
    end
  end

  desc "Run tests for #{device_family}"
  task device_family => "#{device_family}:test"

end

desc 'Build and run tests (the default task)'
task :test => ([:build] + device_families)

task :default => :test
