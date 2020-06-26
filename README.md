# WeatherFetch

A CLI tool for fetching weather data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'weatherfetch'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install weatherfetch

## Usage

#### Get Weekly Forecast
`weatherfetch daily [name_of_city|zip_code|city,state_abbr|city,country_abbr]`

#### Get Hourly Forecast (48 hours)
`weatherfetch hourly [name_of_city|zip_code|city,state_abbr|city,country_abbr]`

#### Notes
* Multi word cities should be passed with a `-` (e.g., `'new-york'`, `'new-zealand'`, `'belo-horizonte'`).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DylanAndrews/weatherfetch.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
