require 'docker'
require 'discordrb'
require './listeners/minecraft'
require './commands/get_container'

# I'm listening
class Listen
  def initialize
    timers = Timers::Group.new
    bot = Discordrb::Commands::CommandBot
          .new(token: ENV['TOKEN'], prefix: ENV['PREFIX'])
    bot.ready do
      minecraft_listener = MinecraftListener.new(bot)
      timers.now_and_every(30) do
        minecraft_listener.listen
      end
      Thread.new { loop { timers.wait } }
      puts 'I\'m in'
    end
    bot.run
  end
end
