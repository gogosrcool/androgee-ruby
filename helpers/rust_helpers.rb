# frozen_string_literal: true

require 'json'
require './helpers/discord_helpers.rb'

# Methods for performaning actions for the Rust server
module RustHelpers
  extend DiscordHelpers

  # @return [String]
  def process_message(event)
    msg = process_rust_json(event)
    return { 'SERVER' => msg['DEBUG'].to_s } if msg['DEBUG'].to_s.include?('used *kill* on ent:')
    return validate_command(msg) if msg['COMMAND']
    return rust_player_join(msg) if msg['DEBUG'].to_s.include?('has entered the game')
    msg
  end

  # @param msg [Hash]
  # @return [Hash]
  def validate_command(msg)
    return if msg['Egee'].nil?
    command = msg['Egee']
    command[0] = ''
    { 'COMMAND' => "{Message: '#{command}', Type: 'Command'}" }
    # TODO: It would be nice to have alias for all players to use
    # if things == 'time day'
    #   { 'COMMAND' => "{Message: 'env.time 11', Type: 'Command'}" }
    # elsif things == 'time night'
    #   { 'COMMAND' => "{Message: 'env.time 23', Type: 'Command'}" }
    # elsif things.include?('teleport')
    #   { 'COMMAND' => "{Message: '#{things}', Type: 'Command'}" }
    # end
  end

  # @param event
  # @return [String, Hash]
  def process_rust_json(event)
    message = JSON.parse(event.data)['Message']
    if message.start_with?('{')
      msg = JSON.parse(message)['Message']
      message = { JSON.parse(message)['Username'] => msg }
      message['COMMAND'] = msg if message.first.to_s.include? '~'
    else
      message = { 'DEBUG' => message }
    end
    filter_rust_messages(message)
  end

  # @param message [Hash]
  # @return [Hash]
  def rust_player_join(message)
    parsed_message = message['DEBUG'].to_s.gsub!(/\[.*\]/, '')
    normalized = parsed_message.sub('entered the game', 'joined')
    { 'COMMAND' => "{Message: 'say #{normalized}', Type: 'Command'}" }
  end

  # @param message [Hash]
  # @return [String, Hash]
  def filter_rust_messages(message)
    message = '' if message['DEBUG'].to_s.include?('totalstall(')
    message = '' if message['DEBUG'].to_s.include?('Saving complete')
    message = '' if message['DEBUG'].to_s.include?('[Manifest]')
    message
  end

  # @return [String]
  def rust_server_message(msg)
    "``#{msg}``"
  end

  # @param server [Discordrb::Server]
  # @return [Discordrb::Channel]
  def rust_channel(server)
    @rust_channel ||= debug_channel(server)
  end
end
