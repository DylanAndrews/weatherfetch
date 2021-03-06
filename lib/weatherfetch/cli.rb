require 'httparty'
require 'thor'
require 'geocoder'
require 'terminal-table'
require 'rainbow'

module WeatherFetch
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc 'hourly', 'Get hourly weather for a given location'
    def hourly(location)
      response = fetch_location_data(location, 'hourly')

      rows = response['hourly'].map do |hour|
        [
          Rainbow(Time.at(hour['dt']).strftime('%m/%d %I %p')).darkolivegreen,
          Rainbow("#{hour['temp']}°F").darkolivegreen,
          Rainbow("#{hour['feels_like']}°F").darkolivegreen,
          Rainbow(hour['weather'][0]['description'].capitalize).darkolivegreen,
          Rainbow("#{hour['humidity']}%").darkolivegreen
        ]
      end

      table = Terminal::Table.new(
        headings: create_headings(['Hour', 'Actual', 'Feels Like', 'Conditions', 'Humidity']),
        rows: rows,
        title: "#{Rainbow(get_title).cornflower}"
      )

      puts table
    end

    desc 'daily', 'Get daily weather for a given location'
    def daily(location)
      response = fetch_location_data(location, 'daily')

      rows = response['daily'].map do |day|
        [
          Rainbow(Time.at(day['dt']).strftime('%m/%d')).darkolivegreen,
          Rainbow("#{day['temp']['min']}°F").darkolivegreen,
          Rainbow("#{day['temp']['max']}°F").darkolivegreen,
          Rainbow("#{day['temp']['morn']}°F").darkolivegreen,
          Rainbow("#{day['temp']['day']}°F").darkolivegreen,
          Rainbow("#{day['temp']['eve']}°F").darkolivegreen,
          Rainbow("#{day['temp']['night']}°F").darkolivegreen,
          Rainbow(day['weather'][0]['description'].capitalize).darkolivegreen,
          Rainbow("#{day['humidity']}%").darkolivegreen
        ]
      end

      table = Terminal::Table.new do |t|
        t.headings = create_headings(['Date', 'Min', 'Max', 'Morning', 'Afternoon', 'Evening', 'Night', 'Conditions', 'Humidity'])
        t.rows = rows
        t.title = "#{Rainbow(get_title).cornflower}"
        t.style = { all_separators: :true }
      end

      puts table
    end

    private
    def create_headings(headings)
      headings.map { |h| Rainbow(h).red }
    end

    def get_title
      city = @location_data.data.dig('address', 'city')
      country = @location_data.data.dig('address', 'country_code').upcase
      state = @location_data.data.dig('address', 'state')

      cleaned_city = city && city.split('-').first
      flag = country.tr('A-Z', "\u{1F1E6}-\u{1F1FF}")

      title = [cleaned_city, state, country].each_with_object('') do |loc, str|
        str << "#{loc}, " if loc
      end

      "#{flag}  #{title.delete_suffix(', ')} #{flag}"
    end

    def fetch_location_data(location, type)
      if @location_data = Geocoder.search(location).first
        latitude, longitude = @location_data.coordinates

        exclusions = ['hourly', 'minutely', 'current', 'daily'].reject do |ex|
          ex == type
        end

        options = {
          query: {
            lat: latitude,
            lon: longitude,
            exclude: exclusions.join(','),
            units: 'imperial',
            appid: 'c8d7f5fd25b8914cc543ed45e6a40bba'
          }
        }
        response = HTTParty.get('http://api.openweathermap.org/data/2.5/onecall', options)
      else
        puts Rainbow('Please enter a valid location').red
        exit
      end
    end
  end
end
