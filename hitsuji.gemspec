Gem::Specification.new do |s|
  s.name = 'hitsuji'
  s.version = '0.3.1'
  s.license = 'MIT'
  s.summary = 'A utility in Ruby for tree data structures with functions.'
  s.description = 'Hitsuji is a library that implements a tree data structure,
  where each node is represented by a value, points to other values, or performs
  a function on some values. When the tree is updated, the inputs to the
  functions will change, hence changing the outputs, eventually propagating the
  update through the entire tree. Data structures can also be exported to disk,
  allowing for wide applications of this software, e.g. handling big data,
  managing content, etc.'
  s.authors = ['Josh Quail']
  s.email = 'josh@madbean.com'
  s.files = ['lib/hitsuji.rb', 'lib/subsystem.rb', 'lib/transfer.rb']
  s.homepage = 'http://rubygems.org/gems/hitsuji'
  s.metadata = {
    'source_code_uri' => 'https://github.com/realtable/hitsuji',
    'bug_tracker_uri' => 'https://github.com/realtable/hitsuji/issues',
    'documentation_uri' => 'https://www.rubydoc.info/gems/hitsuji/' \
      + s.version.to_s + '/Hitsuji'
  }
  s.required_ruby_version = '>= 0'
  s.bindir = 'bin'
  s.executables << 'hitsuji'
  s.add_runtime_dependency 'method_source', '~> 0.9.2'
end
