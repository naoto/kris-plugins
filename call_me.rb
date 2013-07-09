#-*- coding: utf-8
class CallMe < Kris::Plugin

  def on_privmsg(message)
      if message.body =~ /(\d+)秒後に私の名前を読んで|私は誰|whoami/
        time = $1
        sleep time.to_i if time != "" && time =~ /\d+/
        privmsg message.to, message.from.gsub(/(\!.+$)/,"") #.gsub(/_/,"")
      end
  end
end

