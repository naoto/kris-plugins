#-*- coding: utf-8
class Times < Kris::Plugin

  def on_privmsg(message)
    if /^((今|いま)(何時|なんじ)|時差)/ =~ message.body
      japan = Time.now
      us = Time.now.utc - 60 * 60 * 4
      notice(message.to, "日本: #{japan} / NY: #{us}")
    end

  rescue => e
    notice(message.to, e.to_s)
  end
end

