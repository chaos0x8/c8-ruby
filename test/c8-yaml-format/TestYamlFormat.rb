#!/usr/bin/env ruby

require_relative '../../lib/c8-yaml-format'

require 'test/unit'
require 'shoulda'
require 'mocha'

module C8
  class TestYamlFormat < Test::Unit::TestCase
    context('TestYamlFormat') {
      setup {
        @sut = YamlFormat.new
      }

      context('[]') {
        setup {
          @data = ['value1', 'value2']
        }

        should('generate yaml') {
          assert_equal([
            '---',
            '- value1',
            '- value2',
            ''
          ].join("\n"), @sut.pretty_generate(@data))
        }
      }

      context('key => value') {
        setup {
          @data = { 'key' => 'value' }
        }

        should('generate yaml') {
          assert_equal([
            '---',
            'key: value',
            ''
          ].join("\n"), @sut.pretty_generate(@data))
        }
      }

      context('key => []') {
        setup {
          @data = { 'key' => ['value1', 'value2'] }
        }

        should('generate yaml') {
          assert_equal([
            '---',
            'key:',
            '- value1',
            '- value2',
            ''
          ].join("\n"), @sut.pretty_generate(@data))
        }
      }

      context('nested') {
        setup {
          @data = {
            'people' => [
              { 'name' => 'John', 'age' => 10 },
              { 'name' => 'Terry', 'age' => 42 },
              { 'name' => 'Kevin', 'age' => 7, 'toys' => ['car', 'bear'] }
            ],
            'files' => [
              'file1',
              'file2'
            ]
          }
        }

        should('generate yaml') {
          assert_equal([
            '---',
            'people:',
            '- name: John',
            '  age: 10',
            '- name: Terry',
            '  age: 42',
            '- name: Kevin',
            '  age: 7',
            '  toys:',
            '  - car',
            '  - bear',
            'files:',
            '- file1',
            '- file2',
            ''
          ].join("\n"), @sut.pretty_generate(@data))
        }

        context('with indentation=4') {
          setup {
            @sut.indentation = 4
          }

          should('generate yaml') {
            assert_equal([
              '---',
              'people:',
              '-   name: John',
              '    age: 10',
              '-   name: Terry',
              '    age: 42',
              '-   name: Kevin',
              '    age: 7',
              '    toys:',
              '    - car',
              '    - bear',
              'files:',
              '- file1',
              '- file2',
              ''
            ].join("\n"), @sut.pretty_generate(@data))
          }
        }
      }

      context('very long text') {
        setup {
          @sut.line_width = 40
          @sut.indentation = 4
          longLine = (['word'] * @sut.line_width).join(' ')

          @data = {
            'description' => longLine,
            'name' => 'Kevin',
            'methods' => [
              { 'name' => 'goo',
                'description' => longLine,
                'params' => [
                  'a1' => { 'description' => longLine },
                  'a2' => { 'description' => longLine }
                ]},
              { 'name' => 'bar',
                'description' => longLine }
            ]
          }
        }

        should('word break too long text') {
          result = @sut.pretty_generate(@data)
          result.each_line(chomp: true) { |line|
            assert_operator @sut.line_width, :>=, line.size
          }
        }
      }

      context('very long field name') {
        setup {
          @sut.line_width = 40
          @sut.indentation = 4
          longField = 'long_long_description'
          shortLine = (['word'] * 4).join(' ')

          @data = {
            longField => shortLine,
            'name' => 'Kevin',
            'methods' => [
              { 'name' => 'goo',
                longField => shortLine,
                'params' => [
                  'a1' => { longField => shortLine },
                  'a2' => { longField => shortLine }
                ]},
              { 'name' => 'bar',
                longField => shortLine }
            ]
          }
        }

        should('word break too long text') {
          result = @sut.pretty_generate(@data)
          result.each_line(chomp: true) { |line|
            assert_operator @sut.line_width, :>=, line.size
          }
        }
      }
    }
  end
end
