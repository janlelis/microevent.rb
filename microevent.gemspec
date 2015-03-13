# -*- encoding: utf-8 -*-

require File.expand_path('../lib/microevent', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "microevent"
  gem.version       = MicroEvent::VERSION
  gem.summary       = 'MicroEvent.rb is a event emitter library which provides the observer pattern to Ruby objects.'
  gem.description   = 'MicroEvent.rb is a event emitter library which provides the observer pattern to Ruby objects. It is inspired by[MicroEvent.js and implemented in less than 20 lines of Ruby.'
  gem.license       = "MIT"
  gem.authors       = ["Jan Lelis"]
  gem.email         = "mail@janlelis.de"
  gem.homepage      = "https://github.com/janlelis/microevent.rb"

  gem.files         = Dir['{**/}{.*,*}'].select { |path| File.file?(path) }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
