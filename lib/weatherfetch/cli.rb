require 'httparty'
require 'thor'
require 'pry'
require 'geocoder'

module WeatherFetch
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc 'current', 'Get current weather for a given city'
    def current(city)
      options = { query: { q: city, appid: 'c8d7f5fd25b8914cc543ed45e6a40bba' } }
      r = HTTParty.get('http://api.openweathermap.org/data/2.5/weather', options)
      puts r
    end

    desc 'hourly', 'Get hourly weather for a given city'
    def hourly(city)
      longitude, latitude = Geocoder.search(city).first.coordinates

      options = {
        query: {
          lat: latitude,
          lon: longitude,
          appid: 'c8d7f5fd25b8914cc543ed45e6a40bba'
        }
      }
      r = HTTParty.get('http://api.openweathermap.org/data/2.5/onecall', options)
      puts r
    end
  end
end
