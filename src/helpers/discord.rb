# frozen_string_literal: true

Thread.abort_on_exception = true
require 'docker'
require 'timers'

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

  def game_announce(container, player_regex, channel_name)
    unix_time = Time.now.to_i - 30
    logs = container.logs(stdout: true, since: unix_time)
    channel = get_discord_channel(channel_name)
    player = logs.match(player_regex)
    puts player
    if player
      announce = "**#{player}** joined the server"
      channel.send_message announce unless check_last_message(channel, announce) == true
    else
      puts 'nah'
      # debug.send_message 'ya didnt join'
    end
  end
end
