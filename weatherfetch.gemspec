# frozen_string_literal: true
require_relative 'lib/weatherfetch/version'

Gem::Specification.new do |s|
  s.name        = 'weatherfetch'
  s.version     = WeatherFetch::VERSION
  s.date        = '2020-06-19'
  s.summary     = 'Gem for fetching weather data'
  s.authors     = ['Dylan Andrews']
  s.email       = ['dylanandr@gmail.com']
  s.files       = ['lib/weatherfetch.rb']
  s.license     = 'MIT'
  s.executables = 'weatherfetch'

  s.add_dependency 'httparty', '~> 0.17'
  s.add_dependency 'thor', '~> 1.0.1'
  s.add_development_dependency 'pry', '~> 0.13'
end
