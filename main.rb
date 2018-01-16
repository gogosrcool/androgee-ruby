# frozen_string_literal: true

require('./connection_factory.rb')
require('./discord_events.rb')
require('./rust_events.rb')
require('./helpers.rb')
require 'timers'
require 'differ'

$previous_players = []

# The object that does it all!
class Androgee
  def initialize
    json = JSON.parse(File.read('blob.json'))
    connection_factory = ConnectionFactory.new
    bot = connection_factory.discord_connection
    helpers = Helpers.new(bot)
    bot.ready do
      puts 'Connected to Discord Server'
      bot.game = json['games'].sample
      DiscordEvents.new(bot, connection_factory, helpers)
      Thread.new { RustEvents.new(connection_factory, helpers) }
      minecraft_loop(connection_factory, helpers)
    end
    bot.run
  end
  def minecraft_loop(connection_factory, helpers)
    timers = Timers::Group.new
    timers.now_and_every(60) do
      rcon = connection_factory.rcon_connection
      players = rcon.command('list').slice!(30..-1)
      rcon.disconnect

      current_players = players.split(/\s*,\s*/).sort
      diff = current_players - $previous_players

      if diff.empty? == false
        normalized = diff.to_s.chop![1..-1].gsub('"','')
        puts "#{normalized} joined the server"
        helpers.get_discord_channel('minecraft-server').send_message("#{normalized} just joined the server")
      end
      $previous_players = current_players
    end
    Thread.new { loop { timers.wait } }
  end
end

Androgee.new

# bot.command :rust do |event|
#   if event.message.content.include?('time')
#     if @rust_channel.history(1).first.content != event.message.content
#       # redis = Redis.new(host: ENV['REDIS'])
#       # redis.publish('RustCommands', event.message.content)
#       # redis.close
#       'Done'
#     end
#   else
#     'Try again later.'
#   end
# end
