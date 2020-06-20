require 'httparty'

module WeatherFetch
  def foo
    options = { query: { q: 'nashville', appid: 'c8d7f5fd25b8914cc543ed45e6a40bba' }}
    r = HTTParty.get('http://api.openweathermap.org/data/2.5/weather', options)
  end
end
