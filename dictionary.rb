#-*- coding: utf-8

require "nokogiri"
require "open-uri"

class Dictionary < Kris::Plugin
  
  def initialize(*args)
    super
    @code = {"it" => "it" , "r" => "ru", "e" => "en", "j" => "ja", "c" => "zh-CN", "k" => "ko", "f" => "fr", "a" => "ar", "uk" => "uk"}
  end

  def on_privmsg(message)
    if /^(\w{1,2})2(\w{1,2})\s(.+)$/ =~ message.body || /^(e|j)(j|e)\s(.+)$/ =~ message.body
      j = conv($3, $1, $2)
      if j.empty?
        notice(message.to, "スペルミス？")
      else
        notice(message.to, j)
      end
    end
  end

  private
  def conv(e, to, from)
    result = ""
    uri = URI("http://www.google.com/translate_t?langpair=#{@code[to]}%7C#{@code[from]}&text=#{URI::escape(e)}")
    doc = Nokogiri::HTML(open(uri).read)

    say = doc.at("#res-translit").content
    doc.search("span#result_box/span").each do |enc|
      result << "#{enc.content}"
    end
    result << "(#{say})" unless say == ""
    result
  end

end
