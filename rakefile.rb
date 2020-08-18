#!/usr/bin/ruby

gem 'rake-builder', '~> 2.0', '>= 2.0.8'

require 'rake-builder'
require 'rake/testtask'

desc 'Runs unit tests'
Rake::TestTask.new { |t|
  t.test_files = FileList['test/**/*.rb']
  t.deps = ['generated:default']
}

desc 'Builds all gems'
task(:gem => ['c8-ruby:gem', 'c8-yaml-format:gem'])

desc 'Runs unit tests and creates gem file'
task(:default => ['test', 'gem'])
