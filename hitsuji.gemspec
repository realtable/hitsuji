Gem::Specification.new do |s|
  s.name = 'hitsuji'
  s.version = '0.2.0'
  s.license = 'MIT'
  s.summary = 'A utility for creating custom management systems.'
  s.description = 'Hitsuji is a library that lets you easily create, edit,
  manage and apply custom management systems. It is scalable from library card
  databases to performance analysis all the way to complete content management
  systems (like Wordpress.com).'
  s.authors = ['Josh Quail']
  s.email = 'josh@madbean.com'
  s.files = ['lib/hitsuji.rb', 'lib/subsystem.rb', 'lib/transfer.rb']
  s.homepage = 'http://rubygems.org/gems/hitsuji'
  s.metadata = {
    'source_code_uri' => 'https://github.com/realtable/hitsuji',
    'bug_tracker_uri' => 'https://github.com/realtable/hitsuji/issues',
    'documentation_uri' => 'https://www.rubydoc.info/gems/hitsuji/' \
      + s.version.to_s
  }
  s.required_ruby_version = '>= 2.2.0'
end
