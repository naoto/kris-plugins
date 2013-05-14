#-*- coding: utf-8

require 'nokogiri'
require 'open-uri'

class Moon < Kris::Plugin

  API = "http://labs.bitmeister.jp/ohakon/api/"
  ADDRESS = "沖縄県うるま市"

  def on_privmsg(message)
    case message.body
    when /^(満月|ふるふるふるむーん)$/x
      result = search()
      notice(message.to, result)
    end
  end

  private
  def search
    "#{moon_io} #{moon_age} #{full_moon_day}"
  end

  def today
    day = Time.now
    [day.year, day.month, day.day]
  end

  def moon_io
    year, month, day = today
    url = URI.parse(URI.escape("#{API}?mode=moon_rise_set&year=#{year}&month=#{month}&day=#{day}&address=#{ADDRESS}"))
    xml = Nokogiri::XML(url.open.read)
    moonrise = xml.at("result/rise_and_set/moonrise_hm").inner_text
    moonset = xml.at("result/rise_and_set/moonset_hm").inner_text
    "月出:#{moonrise} 月入:#{moonset}"
  end

  def moon_age
    year, month, day =today
    url = URI.parse(URI.escape("#{API}?mode=moon_age&year=#{year}&month=#{month}&day=#{day}"))
    xml = Nokogiri::XML(url.open.read)
    moon_age = xml.at("moon_age").inner_text
    "月齢: #{moon_age}"
  end

  def full_moon_day
    year, month, day = today
    full_moon = full_moon_equation(year, month)
    if full_moon - day == 0
      "今日が満月 ふるふるふるむーん"
    elsif full_moon < day
      next_month = month + 1
      if next_month > 12
        year += 1
        next_month = 1
      end
      next_moon = full_moon_equation(year, next_month)
      "今月の満月は終了しました。 次回は#{next_moon}日です"
    else
      "今月の満月は #{full_moon} 日です"
    end
  end

  def full_moon_equation(year, month)
    moon_cal ={
     2013 => 0,
     2014 => 19,
     2015 => 8,
     2016 => 27
    }

    p = moon_cal[year.to_i]
    (p - month) % 30
  end

end
