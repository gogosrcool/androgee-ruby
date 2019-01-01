require 'docker'
require './connect'
require './listeners/minecraft'
require './commands/get_container'

# I'm listening
class Listen
  def initialize
    test = MinecraftListener.new
    test.lol

    # connect = Connect.new
    # bot = connect.discord
    # bot.ready do
    #   puts 'I\'m in'
    # end
    # bot.run
  end
end
