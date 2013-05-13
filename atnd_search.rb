#-*- coding: utf-8
require 'open-uri'
require 'uri'
require 'nokogiri'

class AtndSearch < Kris::Plugin

  def description
    <<-DESCRIPTION.gsub(/^\s+/, '')
    http://atnd-kensaku.net/
    DESCRIPTION
  end

  def on_privmsg(message)
    case message.body
    when /atnd\s(.+)/
      search(String($1)).each { |event|
        notice message.to, event
      }
    end
  end

  def search(word)
    atnd_list = []
    html = Nokogiri::HTML(open(URI.escape("http://atnd-kensaku.net/?m=list&search=#{word}&area=")).read)
    html.search("#table-01/tbody/tr").each_with_index { |tr,i|
      atnd_list << "#{tr.at("td/a").inner_text}: #{tr.at(".place").inner_text} #{tr.at("td[3]").inner_text} #{tr.at("td/a").attributes["href"]}"
      break if i > 3
    }
    atnd_list << "ないよー" if atnd_list.size == 0
    atnd_list
  rescue => e
    p e
    ["ないよ"]
  end
end

