require "unirest"
# version 1.00
# This is a weather information script that works through command line.
# The script works by making a http get request for information on the weather for a specific city through openweathermap api
# openweathermap api then returns a json object containing the information which is then parsed and displayed on command line.


class Weather
  attr_accessor :city_name, :temp, :max_temp, :min_temp, :avg_temp, :weather_type, :weather_description

  def self.get_weather_information(response)
    city_name = response["city"]["name"]
    list = response["list"]
    temp_data = list[2]["main"]
    weather_info = list[2]["weather"][0]

    current_weather = Weather.new
    current_weather.city_name = city_name
    current_weather.temp = temp_data["temp"]
    current_weather.max_temp = temp_data["temp_max"]
    current_weather.min_temp = temp_data["temp_min"]
    current_weather.avg_temp = (current_weather.max_temp + current_weather.min_temp)/2
    current_weather.weather_type = weather_info["main"]
    current_weather.weather_description = weather_info["description"]
    return current_weather
  end

end

def request(city)
 api_key = "902cff63488c6aac651d53fa8adda64e"
 response = Unirest.get "http://api.openweathermap.org/data/2.5/forecast/weather?q=#{city.downcase}&units=metric&APPID=#{api_key}"
 response.body
end

def run
  input = gets.chomp
  if input.length == 0
    puts "Need more information! Type in the name of another city."
    input = gets.chomp
  end

  current_weather = Weather.get_weather_information(request(input))

  puts "Today the weather in #{current_weather.city_name} is:
        The temperature: #{current_weather.temp}
        The minimum recorded temperature currently is: #{current_weather.min_temp}
        The maximum recorded temperature currently is: #{current_weather.max_temp}
        The average temperature currently is: #{current_weather.avg_temp}
        Today we have: #{current_weather.weather_type}
        To be more specific: #{current_weather.weather_description}
        Do you want to use this service again? Type in 1 for yes 0 for no."
  i = gets.chomp.to_i
  if i == 1
    run
  else
  puts "Bye!"
  end
end

puts "Wealcome to Kofi's weather information service!"
puts "To begin just type in the name of a city."
run
