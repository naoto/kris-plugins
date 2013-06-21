#-*- coding: utf-8

require 'bubs'

class Bub < Kris::Plugin

  def on_privmsg(message)
    case message.body
    when /^bubs\s?(.+)$/x
      words = $1.to_s
      result = Bubs.convert(words)
      notice(message.to, result)
    end
  end
end
