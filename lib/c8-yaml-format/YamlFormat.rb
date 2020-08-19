#!/usr/bin/env ruby

require 'psych'
require 'word_wrap'

module C8
  class YamlFormat
    attr_accessor :indentation, :line_width

    def initialize
      @indentation = 2
      @line_width = 120
    end

    def pretty_generate hash
      hash = wordWrap hash
      Psych.dump(hash, indentation: @indentation)
    end

  private
    def wordWrap data, prefixWidth: 0, level: 0
      if data.kind_of? Hash
        return data.collect { |key, value|
          [key, wordWrap(value, prefixWidth: key.size + 2, level: level+1)]
        }.to_h
      elsif data.kind_of? Array
        return data.collect { |value|
          wordWrap(value, level: level)
        }
      elsif data.kind_of? String
        width = @line_width - level * @indentation

        if data.size > width
          if data.split("\n").any? { |x| x.size > width }
            return WordWrap::ww data, width, true
          end
        elsif data.size > width - prefixWidth
          return WordWrap::ww data, width - prefixWidth, true
        end
      end

      return data
    end
  end
end
