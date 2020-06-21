require 'httparty'
require 'thor'
require 'pry'
require 'geocoder'
require 'terminal-table'

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
      latitude, longitude = Geocoder.search(city).first.coordinates

      options = {
        query: {
          lat: latitude,
          lon: longitude,
          exclude: 'daily,minutely,current',
          units: 'imperial',
          appid: 'c8d7f5fd25b8914cc543ed45e6a40bba'
        }
      }
      response = HTTParty.get('http://api.openweathermap.org/data/2.5/onecall', options)

      rows = response['hourly'].map do |hour|
        [
          Time.at(hour['dt']).strftime('%m/%d %I %p'),
          "#{hour['temp']}°F",
          "#{hour['feels_like']}°F",
          hour['weather'][0]['description'].capitalize,
          "#{hour['humidity']}%"
        ]
      end

      table = Terminal::Table.new(
        rows: rows,
        headings: ['Hour', 'Actual', 'Feels Like', 'Conditions', 'Humidity'],
        title: city.capitalize
      )
      puts table
    end
  end
end
