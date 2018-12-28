require './connect'

# I'm listening
class Listen
  def initialize
    connect = Connect.new
    bot = connect.discord
    bot.ready do
      puts 'I\'m in'
    end
    bot.run
  end
end
