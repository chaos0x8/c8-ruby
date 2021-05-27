#!/usr/bin/ruby

gem 'rake-builder', '~> 2.0', '>= 2.0.8'

require 'rake-builder'
require 'rake/testtask'

desc 'Runs unit tests'
Rake::TestTask.new { |t|
  t.test_files = FileList['test/**/*.rb']
  t.deps = ['generated:default']
}

gemTasks = Dir['*.gemspec'].collect { |fn|
  "#{File.basename(fn).chomp(File.extname(fn))}:default"
}

desc 'Builds all gems'
task(:gem => Names[gemTasks])

desc 'Runs unit tests and creates gem file'
task(:default => Names['test', gemTasks])
