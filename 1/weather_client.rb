
require 'savon'
require 'rexml/document'


class WeatherClient
    def initialize
        #@client = Savon::Client.new "http://localhost:8888/globalweather.asmx?WSDL"
        @client = Savon::Client.new "http://webservicex.com/globalweather.asmx?WSDL"
    end

    def getWeather cityName, countryName
        response = @client.request :get_weather, 
                body: {"CityName" => cityName, "CountryName" => countryName}
        xml = response.to_hash[:get_weather_response][:get_weather_result].to_s
        return xml if xml == "Data Not Found"
        xml["utf-16"] = "utf-8" 
        xmldoc = REXML::Document.new(xml)
        xmldoc.elements.collect("CurrentWeather/*") {|e| e.name + " " + e.text + "\n"}.join
    end

    def getCities countryName
        response = @client.request :get_cities_by_country, body: {"CountryName" => countryName}
        xml = response.to_hash[:get_cities_by_country_response][:get_cities_by_country_result]
        xmldoc = REXML::Document.new(xml.to_s)
        xmldoc.elements.collect("NewDataSet/Table/City") {|city| city.text} 
    end
end

