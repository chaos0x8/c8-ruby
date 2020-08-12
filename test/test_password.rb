#!/usr/bin/env ruby

require 'test/unit'
require 'shoulda'
require 'mocha'

require_relative '../lib/ruby-c8/password'

module C8
  class TestPassword < Test::Unit::TestCase
    context('TestPassword') {
      should('respond to :aquire') {
        assert(Password.respond_to?(:aquire))
      }
    }
  end
end
