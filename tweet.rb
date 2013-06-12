#-*- coding: utf-8
require 'twitter'

Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET']
end

class Tweet < Kris::Plugin

  def on_privmsg(message)
    if /^(twit\s|@)+([^\s]+)[\s]{0,}([\d]{0,})/ =~ message.body
      user = $2
      cnt = $3.to_i || 0

      twit = "#{@user}: #{Twitter.user_timeline(user)[cnt].text}"
      notice(message.to, twit)
    end

  rescue => e
    notice(message.to, e.to_s)
  end
end

