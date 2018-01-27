# frozen_string_literal: true

# Assorted helper methods
class DiscordHelpers
  def initialize(discord)
    @discord = discord
    @egeeio_server = @discord.servers.dig(ENV['EGEEIO_SERVER'].to_i)
    @debug_channel = get_discord_channel('debug')
    @rust_channel = get_discord_channel('debug')
  end

  def debug_notification(message)
    puts message
    @debug_channel.send_message(message)
  end

  def get_discord_channel(channel_name)
    @egeeio_server.text_channels.select do |channel|
      channel.name == channel_name
    end.first
  end

  # Checks latest message for a given Discord channel and returns true or false if messages match
  def check_last_message(channel, msg)
    channel.history(1).first.content.include?(msg)
  end
end
