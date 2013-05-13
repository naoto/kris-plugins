#-*- coding: utf-8

require 'net/http'
require 'nokogiri'
require 'uri'
require 'nkf'

class GoogleMap < Kris::Plugin

  def on_privmsg(message)
    case message.body
    when /
      ^
      (.+)?                  (?# 3: search words)
      ってどこ
      $
    /x
      words  = $1
      #number = $1 && $1.to_i ||
      #         $2 && $2.scan(@prefix).size + 1
      result = search words
      result.each { |line| notice(message.to, line) }
    end
  end

  private
  def search (string, shu=nil)
    result   = Array.new
    keywords = string.split(/\s+/).collect{ |item| URI.escape(item, /[^-.!~*'()\w]/n) }.join('+')
    uri      = URI.parse("http://maps.google.co.jp/maps?f=q&source=s_q&hl=ja&geocode=&q=#{keywords}")
    Net::HTTP.start(uri.host, uri.port) do |http|
      response = http.get(uri.request_uri)
      if response.code.to_i == 200 then
        document = Nokogiri::HTML(response.body)
        document.search(".pp-headline-address").each { |node|
          break if result.size > 0
          line = "[#{NKF.nkf('--utf8',node.inner_text)}] "
          open("http://tinyurl.com/api-create.php?url=#{uri}") do |f|
            line << f.read()
          end
          result << line

        }
      end
      if result.empty?
        result << "わかんない #{uri}"
      end
    end
    result
  end
end
