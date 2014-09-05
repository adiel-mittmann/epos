# -*- coding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'epos'
  s.version     = '0.9.0'
  s.date        = '2014-09-05'
  s.summary     = "Access to the Houaiss dictionary data files"
  s.description = "Provides access to the Houaiss dictionary data files.  Entries can be exported as HTML."
  s.authors     = ["Adiel Mittmann"]
  s.email       = 'adiel@mittmann.net.br'
  s.homepage    = 'https://github.com/adiel-mittmann/epos'
  s.license     = 'GPL3'

  s.files       = %w(LICENSE README.md README.pt-br.md epico.png epos.gemspec) +
                  Dir["lib/**/*.rb"] +
                  Dir["lib/**/*.slim"] +
                  Dir["lib/**/*.css"] +
                  Dir["examples/**/*.rb"]

  s.add_dependency 'slim', '>= 2.0.0'
end
