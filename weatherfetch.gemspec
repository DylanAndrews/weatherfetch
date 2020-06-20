# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'weatherfetch'
  s.version     = '0.0.0'
  s.date        = '2020-06-19'
  s.summary     = 'Gem for fetching weather data'
  s.authors     = ['Dylan Andrews']
  s.email       = ['dylanandr@gmail.com']
  s.files       = ["lib/weatherfetch.rb"]

  s.add_dependency 'httparty'
  s.add_development_dependency 'pry'

end
