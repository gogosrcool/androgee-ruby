require 'docker'
require 'discordrb'
require './connect'
require './listeners/minecraft'
require './commands/get_container'

# I'm listening
class Listen
  def initialize
    bot = Discordrb::Commands::CommandBot
          .new(token: ENV['TOKEN'], prefix: ENV['PREFIX'])
    bot.ready do
      puts 'I\'m in'
      MinecraftListener.new(bot)
    end
    bot.run
  end
end
