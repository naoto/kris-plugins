#-*- coding: utf-8

require 'uri'
require 'nokogiri'
require 'open-uri'

class Nannohi < Kris::Plugin

  def on_privmsg(message)
    case message.body
    when /
      ^
      (今日|きょう)は(なん|何)の(日|ひ)[？?]?
      $
    /x
      result = search()
      notice(message.to, result)
    end
  end

  private
  def search ()
    result = ""
    h = Nokogiri::HTML(open(URI.encode("http://contents.kids.yahoo.co.jp/today/index.html")).read)
    h.search("#dateDtl").each { |l|
       result = l.inner_text()
    }
    return result
  end
end
