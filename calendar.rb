
class Calendar < Kris::Plugin

  def on_privmsg(message)
    if message.body =~ /(cal\s(\d{4})\s(\d{2}))/
      
      arg1 = $2
      arg2 = $3

      year = arg1.length == 4 ? arg1 : arg2
      month = arg1.length == 4 ? arg2 : arg1

      cal(Integer(month),Integer(year)).each{ |i|
        notice message.to, i.gsub(/\s([1-9](\s|$))/,'0\\1').gsub(/\s/,'-')
        sleep 1
      }
    end
  end

  def cal(month, year)
    return ["date not found", "cal month year"] if (month > 12 && month < 1) || year < 1970

    x = `cal #{month} #{year}`
    x.split(/\n/)
  end
end

