require 'weather_jp'

#-*- coding: utf-8
class Weather < Kris::Plugin

  def on_privmsg(message)
      if message.body =~ /^(.+)の(.+)の(天気|てんき)/
        tenki = WeatherJp.parse(message.body).to_s
        notice message.to, tenki if tenki != ""
      end
  end
end

