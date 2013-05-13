require "safe_eval"

class Eval < Kris::Plugin

  def on_privmsg(message)
    case message.body
    when /^rb\s(.+)$/i
      code = Regexp.last_match[1].taint.gsub(/\\([^\\])/){ $1 }
      ret = ""
      begin
        ret = SafeEval.eval(code).inspect
      rescue Exception => e
        ret = "#{e.class.name} => " + e.to_s.inspect
      end
      ret = ret.to_s[/.{200}/] + "..." if ret.scan(/./).size > 200
      notice(message.to, ret.gsub(/\n/, " "))
    end
  end
end
