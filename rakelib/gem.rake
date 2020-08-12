require 'rubygems'

namespace(:gem) {
  gemspec = Gem::Specification.load('ruby-c8.gemspec')
  gemFn = "ruby-c8-#{gemspec.version}.gem"

  file(gemFn => ['ruby-c8.gemspec', 'generated:default']) {
    sh 'gem build ruby-c8.gemspec'
    Dir['*.gem'].sort{ |a, b| File.mtime(a) <=> File.mtime(b) }[0..-2].each { |fn|
      FileUtils.rm(fn, verbose: true)
    }
  }

  task(:default => gemFn)

  task(:install => gemFn) {
    sh 'sudo', 'gem', 'install', '-l', gemFn
  }
}

desc "Builds gem file"
task(:gem => 'gem:default')
