# -*- encoding: utf-8 -*-
require File.expand_path('../lib/caldav/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "agcaldav"
  s.version     = CalDAV::VERSION
  s.summary     = "new Ruby CalDAV client"
  s.description = "yet another new Ruby client for CalDAV calendar and tasks."

  s.required_ruby_version     = '>= 1.9.2'

  s.license     = 'MIT'

  s.homepage    = 'https://github.com/agilastic/agcaldav'
  s.authors     = "Alex Ebeling-Hoppe"
  s.email       = "ebeling-hoppe@agilastic.de"
  # forked from "Martin Povolny" => "https://github.com/martinpovolny", 
  #             "Cannon Matthews" => "https://github.com/loosecannon93", 
  #             "Bradley McCrorey" => "https://github.com/4fthawaiian"

  s.add_runtime_dependency 'icalendar'
  s.add_runtime_dependency 'uuid'
  s.add_runtime_dependency 'builder'
  #s.add_dependency "json"
  #s.add_development_dependency "rspec"  

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
