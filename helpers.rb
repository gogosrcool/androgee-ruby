# frozen_string_literal: true

# Butts
class Helpers
  def initialize(discord)
    @discord = discord
  end
  def debug_notification(message)
    puts message
    get_discord_channel('debug').send_message(message)
  end
  def get_discord_channel(channel_name)
    @discord.servers.dig(ENV['EGEEIO_SERVER'].to_i).text_channels.select do |channel|
      channel.name == channel_name
    end.first
  end
end
