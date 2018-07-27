# frozen_string_literal: true

Thread.abort_on_exception = true
require('./event_handlers/discord_events.rb')
require('./event_handlers/rust_events.rb')
require('./helpers/discord_helpers.rb')
require('./connection_factory.rb')
require('timers')

# The object that does it all!
class Androgee
  def initialize
    initialized = false
    @previous_players = []
    connection_factory = ConnectionFactory.new
    bot = connection_factory.discord_connection
    bot.ready do
      bot.game = JSON.parse(File.read('blob.json'))['games'].sample
      unless initialized
        helpers = DiscordHelpers.new(bot)
        DiscordEvents.new(bot, connection_factory, helpers)
        Thread.new { RustEvents.new(connection_factory, helpers) }
        minecraft_loop(connection_factory, helpers)
        initialized = true
      end
      puts 'Connected to Discord Server'
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
      diff = current_players - @previous_players

      if diff.empty?
        normalized = diff.to_s.chop![1..-1].delete('"')
        annoucement_msg = "#{normalized} joined the server"
        puts annoucement_msg
        helpers.get_discord_channel('minecraft-server')
            .send_message("``#{annoucement_msg}``")
      end
      @previous_players = current_players
    end
    Thread.new { loop { timers.wait } }
  end
end

Androgee.new
