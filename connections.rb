# frozen_string_literal: true

require 'discordrb'
require 'faye/websocket'
require './rcon.rb'

# Factory object that returns connections
module Connections
  module_function

  def discord_connection
    token = ENV.fetch('DISCORD_TOKEN') { ARGV.first }
    client_id = (ENV.fetch('DISCORD_CLIENT_ID') { ARGV.last })&.to_i
    abort('First arg must be a Discord token!') if token.nil?
    Discordrb::Commands::CommandBot.new(token: token, client_id: client_id, prefix: '~')
  end

  def wrcon_connection
    Faye::WebSocket::Client.new("ws://#{ENV['RUST_IP']}:28016/#{ENV['RUST_PASSWORD']}")
  end

  def rcon_connection
    rcon = RCon::Query::Minecraft.new(ENV['MINECRAFT_IP'], ENV['MINECRAFT_PORT'])
    rcon.auth(ENV['MINECRAFT_PASSWORD'])
    rcon
  end
end
