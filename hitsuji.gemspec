Gem::Specification.new do |s|
  s.name = 'hitsuji'
  s.version = '0.0.2'
  s.license = 'MIT'
  s.summary = 'A utility for creating custom management systems.'
  s.description = 'Hitsuji is a library that lets you easily create, edit, manage and apply custom management systems. It is scalable from library card databases to performance analysis all the way to complete content management systems (like Wordpress.com).'
  s.authors = ['Josh Quail']
  s.email = 'josh@madbean.com'
  s.files = ['lib/hitsuji.rb', 'lib/subsystem.rb', 'lib/transfer.rb']
  s.homepage = 'http://rubygems.org/gems/hitsuji'
  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/realtable/hitsuji/issues",
    "documentation_uri" => "https://github.com/realtable/hitsuji#readme",
  }
  s.required_ruby_version = '>= 2.0.0'
end