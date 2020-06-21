require 'httparty'
require 'thor'
require 'pry'
require 'geocoder'
require 'terminal-table'
require 'rainbow'

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
          Rainbow(Time.at(hour['dt']).strftime('%m/%d %I %p')).darkolivegreen,
          Rainbow("#{hour['temp']}°F").darkolivegreen,
          Rainbow("#{hour['feels_like']}°F").darkolivegreen,
          Rainbow(hour['weather'][0]['description'].capitalize).darkolivegreen,
          Rainbow("#{hour['humidity']}%").darkolivegreen
        ]
      end

      headings = ['Hour', 'Actual', 'Feels Like', 'Conditions', 'Humidity'].map do |h|
        Rainbow(h).red
      end

      table = Terminal::Table.new(
        headings: headings,
        rows: rows,
        title: Rainbow(city.capitalize).cornflower
      )
      puts table
    end

    desc 'daily', 'Get daily weather for a given city'
    def daily(city)
      latitude, longitude = Geocoder.search(city).first.coordinates

      options = {
        query: {
          lat: latitude,
          lon: longitude,
          exclude: 'hourly,minutely,current',
          units: 'imperial',
          appid: 'c8d7f5fd25b8914cc543ed45e6a40bba'
        }
      }
      response = HTTParty.get('http://api.openweathermap.org/data/2.5/onecall', options)

      rows = response['daily'].map do |day|
        [
          Rainbow(Time.at(day['dt']).strftime('%m/%d')).darkolivegreen,
          Rainbow("#{day['temp']['morn']}°F").darkolivegreen,
          Rainbow("#{day['temp']['day']}°F").darkolivegreen,
          Rainbow("#{day['temp']['eve']}°F").darkolivegreen,
          Rainbow("#{day['temp']['night']}°F").darkolivegreen,
          Rainbow(day['weather'][0]['description'].capitalize).darkolivegreen,
          Rainbow("#{day['humidity']}%").darkolivegreen
        ]
      end

      headings = ['Date', 'Morning', 'Afternoon', 'Evening', 'Night', 'Conditions', 'Humidity'].map do |h|
        Rainbow(h).red
      end

      table = Terminal::Table.new(
        headings: headings,
        rows: rows,
        title: Rainbow(city.capitalize).cornflower
      )
      puts table
    end
  end
end
