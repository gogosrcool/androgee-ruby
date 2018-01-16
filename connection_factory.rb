# frozen_string_literal: true

require 'faye/websocket'
require 'discordrb'
require './rcon.rb'

# Factory object that returns connections 
class ConnectionFactory
  def discord_connection
    abort('First arg must be a Discord token!') if ARGV.first.nil?
    Discordrb::Commands::CommandBot.new(token: ARGV.first, prefix: '~')
  end

  def wrcon_connection
    Faye::WebSocket::Client.new('ws://' + ENV['RUST_IP'] + ':28016/' + ENV['RUST_PASSWORD'])
  end

  def rcon_connection
    rcon = RCon::Query::Minecraft.new(ENV['MINECRAFT_IP'], ENV['MINECRAFT_PORT'])
    rcon.auth(ENV['MINECRAFT_PASSWORD'])
    rcon
  end
end
