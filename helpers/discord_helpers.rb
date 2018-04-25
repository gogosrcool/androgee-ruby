# frozen_string_literal: true

# Assorted helper methods
module DiscordHelpers
  # @param server [Discordrb::Server]
  # @param message [String]
  def debug_notification(server, message)
    puts message
    debug_channel(server).send_message(message)
  end

  # @param server [Discordrb::Server]
  # @param channel_name [String]
  # @return [Discordrb::Channel]
  def discord_channel(server, channel_name)
    server.channels.select { |x| x.name == channel_name }.first
  end

  # Checks latest message for a given Discord channel
  # and returns true or false if messages match
  #
  # @param channel [Discordrb::Channel]
  # @param msg [String]
  # @return [true, false]
  def check_last_message(channel, msg)
    channel.history(1).first.content.include?(msg)
  end

  # @param channel [Discordrb::Channel]
  def delete_last_message(channel)
    channel.history(1).first.delete
  end

  # @param server [Discordrb::Server]
  # @return [Discordrb::Channel]
  def debug_channel(server)
    @debug_channel ||= discord_channel(server, 'debug')
  end
end
