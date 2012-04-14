
require 'gtk2'
require './country_names'
require './weather_client'


class RubyApp < Gtk::Window
    def initialize
        super
        set_title "Weather Client"
        signal_connect "destroy" do 
            Gtk.main_quit 
        end
        
        @cloud_image = Gtk::Image.new "cloud.png"
        @sun_image = Gtk::Image.new "sun.png"
        @cry_image = Gtk::Image.new "cry.png"
        @smile_image = Gtk::Image.new "smile.png"
        init_ui

        set_default_size 250, 400
        set_window_position Gtk::Window::POS_CENTER
        @weatherClient = WeatherClient.new
        show_all

        @cloud_image.visible = false
        @sun_image.visible = false
        @cry_image.visible = false
    end
    
    def init_ui
        fixed = Gtk::Fixed.new

        cb1 = Gtk::ComboBox.new
            cb1.signal_connect "changed" do |w|
                on_changed1(w)
        end
        
        CONTINENTS.keys.each {|cont| cb1.append_text cont}
        
        @cb2 = Gtk::ComboBox.new
            @cb2.signal_connect "changed" do |w|
                on_changed2(w)
        end

        @cb3 = Gtk::ComboBox.new 
            @cb3.signal_connect "changed" do |w|
                on_changed3(w)
        end
        
        cb1.set_width_request 200
        @cb2.set_width_request 200
        @cb3.set_width_request 200


        fixed.put cb1, 30, 30

        fixed.put @cb2, 30, 53
        
        fixed.put @cb3, 30, 76
        @weatherLabel = Gtk::Label.new "Choose some location"

        fixed.put @weatherLabel, 0, 150        
        fixed.put @cloud_image, 50, 350
        fixed.put @sun_image, 50, 350
        fixed.put @cry_image, 50, 350
        fixed.put @smile_image, 50, 350
        add fixed
    end

    def on_changed1 sender
        @cb2.model = Gtk::ListStore.new String
        @cb3.model = Gtk::ListStore.new String
        countries = CONTINENTS[sender.active_text]
        countries.each {|country| @cb2.append_text country}
    end

    
    def on_changed2 sender
        @cb3.model = Gtk::ListStore.new String
        @country = sender.active_text
        cities = @weatherClient.getCities @country
        cities.each {|city| @cb3.append_text city}
    end


    def on_changed3 sender
        @weatherLabel.set_text @weatherClient.getWeather sender.active_text, @country
        @smile_image.visible = false
        if @weatherLabel.text == "Data Not Found"
            @sun_image.visible = false
            @cloud_image.visible = false
            @cry_image.visible = true
        elsif @weatherLabel.text.include? "cloud" or @weatherLabel.text.include? "overcast"
            @sun_image.visible = false
            @cry_image.visible = false
            @cloud_image.visible = true
        else
            @cloud_image.visible = false
            @cry_image.visible = false
            @sun_image.visible = true
        end
    end
end



Gtk.init
    window = RubyApp.new
Gtk.main


