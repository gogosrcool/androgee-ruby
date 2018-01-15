# frozen_string_literal: true

require './rcon.rb'
require 'discordrb'

# Butts
class ConnectionFactory
  def discord_connection
    abort('First arg must be a Discord token!') if ARGV.first.nil?
    Discordrb::Commands::CommandBot.new(token: ARGV.first, prefix: '~')
  end

  def wrcon_connection
  end

  def rcon_connection
  end
end
