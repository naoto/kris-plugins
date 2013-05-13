#-*- coding: utf-8
class Timer < Kris::Plugin

  def initialize(*args)
    super
    @time = {}
  end

  def on_privmsg(message)
    if message.body =~ /^(スタート|ストップ|start|stop)$/

      key = $1.to_s.downcase
      if key == 'スタート' || key == 'start'
        @time[message.from.gsub(/(\!.+$)/,"")] = Time.now
        reply = 'ok'
      elsif key == 'ストップ' || key == 'stop'
        start = @time[message.from.gsub(/(\!.+$)/,"")]
        stop = Time.now
        hours = (stop - start).divmod(60*60)
        mins = hours[1].divmod(60)
        reply = "#{hours[0].to_i} 時間 #{mins[0].to_i} 分 #{mins[1].to_i} 秒"
      end
      notice message.to, reply
    end
  end
end

