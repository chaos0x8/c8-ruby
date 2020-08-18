require 'rubygems'

namespace('c8-ruby') {
  libName = File.basename(__FILE__).chomp(File.extname(__FILE__))

  gemspec = Gem::Specification.load("#{libName}.gemspec")
  gemFn = "#{libName}-#{gemspec.version}.gem"

  gem = GeneratedFile.new { |t|
    t.name = gemFn
    t.requirements << ["#{libName}.gemspec", 'generated:default']
    t.action = proc { |dst, src|
      sh 'gem', 'build', src
      oldGems = Dir["#{libName}-*.gem"] - [dst]
      oldGems.each { |fn|
        FileUtils.rm(fn, verbose: true)
      }
    }
  }

  C8.task(:gem => Names[gem])

  C8.task(:default => Names[gem])

  C8.task(:install => Names[gem]) {
    sh 'sudo', 'gem', 'install', '-l', gem.name
  }
}

