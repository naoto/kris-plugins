#-*- coding: utf-8
require 'open-uri'
require 'nokogiri'
require 'kconv'

class Twitter < Kris::Plugin

  def on_privmsg(message)
    if /^(twit\s|@)+([^\s]+)[\s]{0,}([\d]{0,})/ =~ message.body
      user = $2
      cnt = $3.to_i || 0
      url = "http://api.twitter.com/1/statuses/user_timeline/#{user}.rss"
      if cnt > 19
        page = ((cnt + 1) / 20).ceil + 1
        url << "?page=#{page}"
        cnt = cnt % 20
      end

      html = Nokogiri::HTML(open(url).read)
      tweet = html.search("item/title")[cnt]
      if !tweet.nil?
        twit = "@#{tweet.content}".gsub(/[\n\r]/,'')
        #twit = "@#{user}: #{twit.content} (#{date.content}) #{URI.short_uri(link)}"
      else
        twit = html.search("h1.logged-out").first
        if twit.nil?
          twit = "だれそれ"
        else
          twit = twit.inner_text.gsub(/[\n\r]/,' ')
        end
      end
      notice(message.to, twit)
    end

  rescue => e
    notice(message.to, e.to_s)
  end
end

