# frozen_string_literal: true

# Butts
class Helpers
  def initialize(discord)
    @discord = discord
    @egeeio_server = @discord.servers.dig(ENV['EGEEIO_SERVER'].to_i)
    @debug_channel = get_discord_channel('debug')
    @rust_channel = get_discord_channel('rust-server')
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

  def process_rust_message(message)
    msg = filter_rust_messages(message)
    if msg.include?('has entered the game')
      rust_player_join(msg)
    elsif msg.include?('[ServerVar]')
      @rust_channel.send_message(msg)
    elsif msg.include?('(no reason given)')
      @rust_channel.send_message(msg)
    elsif msg.empty? == false
      { 'debug' => msg }
    end
  end

  def rust_player_join(message)
    parsed_message = message.gsub!(/\[.*\]/, '')
    if @rust_channel.history(1).first.content != parsed_message
      @rust_channel.send_message(parsed_message)
      normalized = parsed_message.sub('entered the game', 'joined')
      { 'server' => "{Message: 'say #{normalized}', Type: 'Command'}" }
    end
  end

  def filter_rust_messages(message)
    # TODO: Filter out plain chat text
    return '' if message.include?('totalstall(')
    return '' if message.include?('Saving complete')
    return '' if message.include?('[Manifest]')
    return '' if message.include?('RUST SERVER:')
    return '' if message.include?('RUST DEBUG:')
    message # Return if nothing is filtered
  end
end
