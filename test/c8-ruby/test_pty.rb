#!/usr/bin/env ruby

require 'test/unit'
require 'shoulda'
require 'mocha'

require_relative '../../lib/c8-ruby/pty'

module C8
  class TestPty < Test::Unit::TestCase
    def self.spawn_capture_tests
      proc {
        should('spawn') {
          pid, st = Pty.spawn(args: @args, expects: @expects, out: @out)

          assert_equal(@expectedOutput, @out.string)
          assert_equal(0, st.exitstatus)
        }

        should('capture') {
          string, st = Pty.capture(args: @args, expects: @expects)

          assert_equal(@expectedOutput, string)
          assert_equal(0, st.exitstatus)
        }
      }
    end

    context('TestPty') {
      setup {
        @out = StringIO.new
      }

      context('.') {
        setup {
          @args = ['ruby', '-e', 'puts "Hello"']
          @expects = {}
          @out = StringIO.new

          @expectedOutput = "Hello\r\n"
        }

        merge_block(&spawn_capture_tests)
      }

      context('with expects') {
        setup {
          @args = ['ruby', '-e', 'print "Tell me your name: "',
                           '-e', 'name = gets',
                           '-e', 'puts "Thank you #{name}"']
          @expects = { 'Tell me your name:' => 'Ene' }

          @expectedOutput = "Tell me your name: Ene\r\nThank you Ene\r\n"
        }

        merge_block(&spawn_capture_tests)
      }
    }
  end
end

