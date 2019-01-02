# frozen_string_literal: true

require 'docker'

# Assorted helper methods
class DiscordHelpers
  def initialize(discord)
    @discord = discord
  end

  def get_discord_channel(channel_name)
    @discord.servers
            .dig(ENV['SERVER_ID'].to_i)
            .text_channels.select do |channel|
      channel.name == channel_name
    end.first
  end

  def check_last_message(channel, msg)
    channel.history(1).first.content.include?(msg)
  end

  def delete_last_message(channel)
    channel.history(1).first.delete
  end

  def game_announce(container, player_regex, channel)
    unix_time = Time.now.to_i - 30
    logs = container.logs(stdout: true, since: unix_time)
    debug = get_discord_channel(channel)
    player = logs.match(player_regex)
    puts player
    if player
      announce = "**#{player}** joined the server"
      debug.send_message announce unless check_last_message(debug, announce) == true
    else
      puts 'no'
      # debug.send_message 'ya didnt join'
    end
  end
end
