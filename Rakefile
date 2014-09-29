require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rubygems/package_task'
require 'rdoc/task'
require 'rspec/core/rake_task'

spec = Gem::Specification.new do |s|
  s.name = 'PageApp'
  s.version = '0.0.1'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = 'A page generator for camera works'
  s.description = s.summary
  s.author = ''
  s.email = ''
  s.executables = ['app.rb']
  s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

Rake::RDocTask.new do |rdoc|
  files =['README', 'LICENSE', 'lib/**/*.rb']
  rdoc.rdoc_files.add(files)
  rdoc.main = "README" # page to start on
  rdoc.title = "Page App Docs"
  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
  rdoc.options << '--line-numbers'
end

RSpec::Core::RakeTask.new(:spec)

desc 'run app'
task :app, [:file, :dir] do |t, args|
  args.with_defaults(:file => './works.xml', :dir => 'out') if args.keys.nil?
  system("ruby app.rb #{args[:file]} #{args[:dir]}")
end

desc 'read API documentation in a browser'
task :read_rdoc do
  Rake::Task["rdoc"].invoke()
  system("xdg-open ./doc/rdoc/README.html &")
end

# set default task to run the app
task :default => :app
