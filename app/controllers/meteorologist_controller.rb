require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("meteorologist/street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]

    # ==========================================================================
    # Your code goes below.
    #
    # The street address that the user typed is in the variable @street_address.
    # ==========================================================================

    street_address_without_spaces = @street_address.gsub(" ","+")
    full_url = "http://maps.googleapis.com/maps/api/geocode/json?address="+street_address_without_spaces+"&sensor=false"
    parsed_data = JSON.parse(open(full_url).read)

    latitude = parsed_data["results"][0]["geometry"]["location"]["lat"]
    longitude = parsed_data["results"][0]["geometry"]["location"]["lng"]

    full_url_meteorologist = "https://api.darksky.net/forecast/a907916f2a5d831967aadea6833592a7/"+latitude.to_s+","+longitude.to_s
    parsed_data_meteorologist = JSON.parse(open(full_url_meteorologist).read)

    @current_temperature = parsed_data_meteorologist["currently"]["temperature"]

    @current_summary = parsed_data_meteorologist["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data_meteorologist["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data_meteorologist["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data_meteorologist["daily"]["summary"]

    render("meteorologist/street_to_weather.html.erb")
  end
end
