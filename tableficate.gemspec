# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tableficate/version"

Gem::Specification.new do |s|
  s.name        = "tableficate"
  s.version     = Tableficate::VERSION
  s.authors     = ["Aaron Lasseigne"]
  s.email       = ["alasseigne@sei-mi.com"]
  s.homepage    = "https://github.com/sei-mi/tableficate"
  s.summary     = %q{Simple tables for Rails.}
  s.description = %q{Simple tables for Rails.}

  s.rubyforge_project = "tableficate"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '>= 3.1'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sqlite3'
end
