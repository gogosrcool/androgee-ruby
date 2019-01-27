Thread.abort_on_exception = true
require 'yaml'
require 'timers'
require 'docker'
require 'discordrb'
require './lib/listeners/rust'
require './lib/listeners/minecraft'
require './lib/handlers/discord'

# I'm listening
module Listen
  def self.start
    @timers = Timers::Group.new
    @bot = Discordrb::Commands::CommandBot.new(token: ENV['TOKEN'], prefix: ENV['PREFIX'])
    @bot.include! DiscordEvents
    @bot.ready do |event|
      event.bot.game = YAML.load_file('./config.yml')['games'].sample
      game_loop
    end
    @bot.run
  end

  def self.game_loop
    puts 'and away we go'
    @timers.now_and_every(30) do
      RustListener.listen(@bot)
      MinecraftListener.listen(@bot)
    end
    Thread.new { loop { @timers.wait } }
  end
end
