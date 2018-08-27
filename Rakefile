require 'rake/testtask'
require 'rdoc/task'

RDoc::Task.new :rdoc do |rdoc|
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_dir = 'doc'
end

Rake::TestTask.new :test do |t|
  t.libs << 'test'
end

task :build do
  Rake::Task[:test].invoke
  Rake::Task[:rdoc].invoke
end

task default: :build
