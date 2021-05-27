require 'rubygems'

autoload :FileUtils, 'fileutils'

Dir['*.gemspec'].each { |fn|
  libName = File.basename(fn).chomp(File.extname(fn))

  namespace(libName) {
    gemspec = Gem::Specification.load("#{libName}.gemspec")
    gemFn = "#{libName}-#{gemspec.version}.gem"

    gem = GeneratedFile.new { |t|
      t.name = gemFn
      t.requirements << ["#{libName}.gemspec", "generated:default"]
      t.action = proc { |dst, src|
        sh 'gem', 'build', src
        oldGems = Dir["#{libName}-*.gem"] - [dst]
        oldGems.each { |fn|
          FileUtils.rm(fn, verbose: true)
        }
      }
    }

    desc "Builds #{libName}"
    C8.task(:default => Names[gem])

    desc "Builds and install #{libName}"
    C8.task(:install => Names[gem]) {
      sh 'sudo', 'gem', 'install', '-l', gem.name
    }
  }
}

