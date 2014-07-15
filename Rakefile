require 'rake'
require 'puppet'
require 'puppet/module_tool'
require 'rspec/core/rake_task'
require 'puppetlabs_spec_helper/rake_tasks'

# Remove Tasks from puppet_spec_helper
Rake::Task['beaker'].clear
Rake::Task['beaker_nodes'].clear
Rake::Task['build'].clear
Rake::Task['coverage'].clear
Rake::Task['spec'].clear
Rake::Task['spec_standalone'].clear
Rake::Task['syntax'].clear
Rake::Task['validate'].clear

@path = File.expand_path('.')

# Return Data about our Module
def read_metadata
  return @metadata if @metadata

  @metadata = Puppet::ModuleTool::Metadata.new

  unless @path
    raise ArgumentError, "Could not determine module path"
  end

  modulefile_path = File.join(@path, 'Modulefile')
  metadata_path   = File.join(@path, 'metadata.json')
  has_metadata    = File.file?(modulefile_path) || File.file?(metadata_path) 

  if !has_metadata
    raise ArgumentError, "No metadata found for module #{@path}"
  end

  if File.file?(metadata_path)
    File.open(metadata_path) do |f|
      begin
        @metadata.update(JSON.load(f))
      rescue JSON::ParserError => ex
        raise ArgumentError, "Could not parse JSON #{metadata_path}", ex.backtrace
      end
    end
  end

  if File.file?(modulefile_path)
    if File.file?(metadata_path)
      puts "Modulefile is deprecated. Merging your Modulefile and metadata.json."
    else
      puts "Modulefile is deprecated. Building metadata.json from Modulefile."
    end
    Puppet::ModuleTool::ModulefileReader.evaluate(@metadata, modulefile_path)
  end

  return @metadata
end

def capture(*streams)
  streams.map! { |stream| stream.to_s }
  begin
    result = StringIO.new
    streams.each { |stream| eval "$#{stream} = result" }
    yield
  ensure
    streams.each { |stream| eval("$#{stream} = #{stream.upcase}") }
  end
  result.string
end

# Default Task
desc 'Show Available Tasks and Exit.'
task :help do
  system('rake -T')
end

task :default => [:help]

# Unlisted Tasks

# Generate metadata.json
task :version_bump do
  @metadata = read_metadata unless @metadata

  if @metadata

    # Current Version
    cv = @metadata.version

    # New Version
    nv = Gem::Version.new("#{cv}.0").bump.to_s

    # Print New Version Details
    puts "Bumping Module version from #{cv} to #{nv}"

    # Update Version in metadata
    @metadata.update('version' => nv)

    # Update Modulefile with new Version
    if File.exists?('Modulefile')
      ModuleText = File.read('Modulefile').gsub(/\nversion[ ]+['"].*['"]/, "\nversion      '#{nv}'")
      begin
        fh = File.open('Modulefile', 'w')
        fh.write(ModuleText)
      rescue IOError => e
        abort("Error Updating Modulefile")
      ensure
        fh.close unless fh == nil
      end
    end
  end
end

# Generate metadata.json
task :generate_metadata do
  @metadata = read_metadata unless @metadata

  if @metadata
    
    @metadata.update('issues_url' => '')

    # Generate Checksums
    checksums = Puppet::ModuleTool::Checksums.new(File.expand_path File.dirname(__FILE__))

    # Update our @metadata with the new checksums
    @metadata.update('checksums' => checksums)

    # Generate metadata.json
    json = PSON.pretty_generate(@metadata)
    begin
      fh = File.open('metadata.json','w')
      fh.write(json)
    rescue IOError => e
      abort("Error Generating metadata.json")
    ensure
      fh.close unless fh == nil
    end
    
  end
end

# Puppet Paser Checks
task :check_syntax do
  successes = []
  failures  = []
  errors    = []

  puts "Checking Manifests Syntax"

  Dir.glob('**/*.pp').each do |manifest|
    puts "Evaluating #{manifest}"
    cout = `puppet parser validate --noop --storeconfigs #{manifest} 2>&1`
    if $? != 0
      failures  << manifest
      errors    << cout
    else
      successes << manifest
    end
  end

  total_manifests = successes.count + failures.count

  # Print the results.
  puts
  puts "Total Files: #{total_manifests}"
  puts "Success:     #{successes.count}"
  puts "Failures:    #{failures.count}"
  puts

  # Fail the task if any files failed syntax check.
  if failures.count > 0
    # Print out Errors
    puts "Errors:"
    errors.each do  |err|
      puts err
    end
    abort("Errors found parsing Manifests")
  end
end

# ERB Template Syntax Checks
task :check_templates do
  errors  = []
  success = []

  puts "Checking ERB Templates Syntax"

  files = Dir.glob('templates/**/*').select { |f| !File.directory? f }
  files.each do |f|
    puts "Evaluating #{f}"
    cout = `erb -x -T '-' #{f} | ruby -c 2>&1`
    if $? != 0
      errors << cout
    else
      success << cout
    end
  end
  puts
  puts "Total Files: #{files.count}"
  puts "Success:     #{success.count}"
  puts "Failures:    #{errors.count}"
  puts
  if errors.count > 0
    puts "Errors:"
    errors.each do |err|
      puts err.to_s
    end
    abort("Error Validating ERB Templates")
  end
end

# Ruby Plugin Syntax Checks
task :check_plugins do
  errors  = []
  success = []

  puts "Checking Ruby Files Syntax"

  files = Dir.glob('lib/**/*.rb').each do |f|
    puts "Evaluating #{f}"
    cout = `ruby -c #{f} 2>&1`
    if $? != 0
      errors << cout
    else
      success << cout
    end
  end
  puts
  puts "Total Files: #{files.count}"
  puts "Success:     #{success.count}"
  puts "Failures:    #{errors.count}"
  puts
  if errors.count > 0
    puts "Errors:"
    errors.each do |err|
      puts err.to_s
    end
    abort("Error Validating Ruby Files")
  end
end

# Puppet Lint
task :lint do 
  output = []
  success  = 0
  failures = 0

  begin
    require 'puppet-lint'
  rescue LoadError
    fail 'Cannot load puppet-lint, did you install it?'
  end
 
  puts "Checking Manifests Style"
 
  linter = PuppetLint.new
  linter.configuration.ignore_paths = [ "pkg/**/*", "vendor/**/*", "spec/**/*", "doc/**/*" ]
  linter.configuration.fail_on_warnings = false
  linter.configuration.with_filename = true
  linter.configuration.send('disable_80chars')
  linter.configuration.send('disable_class_inherits_from_params_class')

  FileList['**/*.pp'].each do |puppet_file|
    puts "Evaluating #{puppet_file}"
    linter.file = puppet_file
    output << capture(:stdout, :stderr) { linter.run }
  end

  @stats = linter.instance_variable_get('@statistics')

  puts
  puts "Total Files: #{output.count}"
  puts "Warnings:    #{@stats[:warning]}"
  puts "Errors:      #{@stats[:error]}"
  puts

  if @stats[:error] > 0 || @stats[:warning] > 0
    output.each do |msg|
      unless msg.empty?
        puts msg.to_s
      end
    end
    puts
  end
  if linter.errors? || ( linter.warnings? && linter.configuration.fail_on_warnings )
    abort "Errors Detected Checking Code Style"
  end
end

# Module Layout Checks
task :check_layout do
  errors  = []
  # Check Modulefile
  unless File.exists?('Modulefile')
    errors << "Missing Modulefile"
  end
  # Check LICENSE
  unless File.exists?('LICENSE')
    errors << "Missing Module LICENSE"
  end
  # Check README.md
  unless File.exists?('README.md')
    errors << "Missing Module README.md"
  end

  if errors.count > 0
    puts "Validating Module Layout"
    puts
    puts "Errors: #{errors.count}"
    puts
    errors.each do |err|
      puts err
    end
    puts
  end
end

# Public Tasks

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end

desc 'Bump Module Version'
task :bump => [ :version_bump, :generate_metadata ]

desc 'Validate Module'
task :test => [ :check_layout, :check_syntax, :lint, :check_templates, :check_plugins, :spec ]
