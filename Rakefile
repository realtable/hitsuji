require 'rake/testtask'
require 'rdoc/task'

Rake::TestTask.new :test do |t|
  t.libs << 'test'
end

RDoc::Task.new :rdoc do |t|
  t.rdoc_files.include('lib/**/*.rb')
  t.rdoc_dir = 'doc'
end

task :build do
  Rake::Task[:test].invoke
  Rake::Task[:rdoc].invoke
end

task default: :build
