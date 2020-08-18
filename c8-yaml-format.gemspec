Gem::Specification.new { |s|
  s.name = 'c8-yaml-format'
  s.version = '0.0.0'
  s.date = '2020-08-12'
  s.summary = "#{s.name} library"
  s.description = 'Library for formatting yaml files'
  s.authors = ['chaos0x8']
  s.files = Dir['lib/c8-yaml-format.rb', 'lib/c8-yaml-format/**/*.rb', 'bin/c8-yaml-format']
  s.executables = ['c8-yaml-format']

  s.add_dependency 'psych', '~> 2.0'
  s.add_dependency 'word_wrap', '~> 1.0', '>= 1.0.0'
}
