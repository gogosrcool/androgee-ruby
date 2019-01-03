require 'docker'
require 'discordrb'
require './listeners/minecraft'

# I'm listening
class Listen
  def initialize
    @timers = Timers::Group.new
    @bot = Discordrb::Commands::CommandBot.new(token: ENV['TOKEN'], prefix: ENV['PREFIX'])
    discord
  end

  def discord
    @bot.ready do
      puts 'I\'m listening'
      game_loop
    end
    @bot.run
  end

  def game_loop
    minecraft_listener = MinecraftListener.new(@bot)
    @timers.now_and_every(30) do
      minecraft_listener.listen
    end
    Thread.new { loop { @timers.wait } }
  end
end
