# frozen_string_literal: true

require 'timers'
require './helpers/discord_helpers.rb'

module MinecraftEvents
  extend Discordrb::Commands::CommandContainer
  extend Discordrb::EventContainer
  extend DiscordHelpers

  ready do |event|
    server = event.bot.server(ENV['EGEEIO_SERVER'].to_i)
    @previous_players ||= []
    @minecraft_loop ||= minecraft_loop(server)
  end

  command :minecraft_list do |event|
    rcon = Connections.rcon_connection
    players = rcon.command('list')[30..-1]
    rcon.disconnect

    current_players = players.split(/\s*,\s*/).sort
    normalized = current_players.to_s.chop[1..-1].delete('"')
    get_discord_channel(event.server, 'minecraft-server')
      .send_message("The following players are online: #{normalized}")
  end

  module_function

  def minecraft_loop(server)
    timers = Timers::Group.new
    timers.now_and_every(60) do
      rcon = Connections.rcon_connection
      players = rcon.command('list')[30..-1]
      rcon.disconnect

      current_players = players.split(/\s*,\s*/).sort
      diff = current_players - @previous_players

      if diff.empty? == false
        normalized = diff.to_s.chop[1..-1].delete('"')
        annoucement_msg = "#{normalized} joined the server"
        puts annoucement_msg
        get_discord_channel(server, 'minecraft-server')
          .send_message("``#{annoucement_msg}``")
      end
      @previous_players = current_players
    end
    Thread.new { loop { timers.wait } }
  end
end
