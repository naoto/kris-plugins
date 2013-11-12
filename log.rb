require 'sqlite3'
require 'sinatra'

class Log < Kris::Plugin

  def initialize(*args)
    super
    @channel = "#TwitterOkinawa@freenode"
    @sqlite = Sqlite.new
    @thread = Thread.new do
      Signal.trap(:INT){
        exit(0)
      }
      @server = Web.run!( port: 9999, bind: "0.0.0.0")
    end
  end

  def on_privmsg(message)
    logging(:priv, message.to, message.from, message.body)
  end

  def on_notice(message)
    logging(:notice, message.to, message.from, message.body)
  end

  def logging(command, to, from, body)
    @sqlite.puts(command, to, from, body) if to == @channel
  end

  class Sqlite

    DBNAME = "./log.sqlite3"
    CREATE_TABLE = "create table logs ( id integer primary key autoincrement, channel text, command text,  user text, message text, created_at datetime, updated_at datetime )"

    def initialize
      @sqlite = SQLite3::Database.new(DBNAME)
      @sqlite.execute(CREATE_TABLE) unless init?
    end

    def puts(command, to, from, body)
      @sqlite.execute("INSERT INTO logs(channel, command, user, message, created_at, updated_at) values (?,?,?,?,?,?)",
                        to, command.to_s, from, body, Time.now.to_s, Time.now.to_s)
    end

    def page(page = 1)
      page = 1 if page == 0
      offset = (page - 1) * 30
      @sqlite.execute("select * from logs order by id desc limit 30 offset #{offset}")
    end

    private
      def init?
        @sqlite.execute("SELECT tbl_name FROM sqlite_master WHERE type == 'table' AND tbl_name != 'sqlite_sequence'").flatten.include?("logs")
      end

  end

  class Web < Sinatra::Base

    set :sqlite, Sqlite.new
    set :views, File.dirname(__FILE__) + '/logview'

    get '/' do
      redirect '/1'
    end

    get '/:page' do
      @page = (params[:page] || 1).to_i
      @logs = settings.sqlite.page(@page)
      erb :index
    end
  end

end
