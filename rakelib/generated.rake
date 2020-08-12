namespace(:generated) {
  generated = ['lib/ruby-c8'].collect { |dir|
    GeneratedFile.new { |t|
      t.name = "#{dir}.rb"
      t.requirements << FileList[File.join(dir, '*.rb')]
      t.code = proc {
        d = []
        d << '#!/usr/bin/env ruby'
        d << ''
        t.requirements.each { |fn|
          d << "require_relative '#{File.basename(dir)}/#{File.basename(fn)}'"
        }
        d
      }
    }
  }

  C8.multitask(default: Names[generated])
}
