#-*- coding: utf-8
require 'net/http'
require 'rubygems'
require 'nokogiri'
require 'uri'
require 'open-uri'

class Taihu < Kris::Plugin

  def on_privmsg(message)
    case message.body
    when /
      ^
      (台風|たいふう)どうなった
    /x
      result = search
      result.each { |line| notice(message.to, line) }
    end
  end

  private
  def search ()
    result   = Array.new
    html = Nokogiri::HTML(open("http://typhoon.yahoo.co.jp/weather/jp/typhoon/").read)
    html.search(".yjw_main_md").each { |tr|
      result << tr.content.gsub(/\s+/,' ').strip[0..250] if /^(台風)/ =~ tr.content
    }
    result << "http://typhoon.yahoo.co.jp/weather/jp/typhoon/"
    result
  end
end
