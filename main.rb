# frozen_string_literal: true

require('./connection_factory.rb')
require('./discord_events.rb')
require 'json'

# Farts
class Androgee
  def initialize
    @json = JSON.parse(File.read('blob.json'))
    @connection_factory = ConnectionFactory.new
    @bot = @connection_factory.discord_connection
    @bot.ready do
      puts 'Connected to Discord Server'
      @bot.game = @json['games'].sample
      DiscordEvents.new(@bot)
    end
    @bot.run
  end
end

Androgee.new

# @bot.command :rust do |event|
#   if event.message.content.include?('time')
#     if @rust_channel.history(1).first.content != event.message.content
#       # redis = Redis.new(host: ENV['REDIS'])
#       # redis.publish('RustCommands', event.message.content)
#       # redis.close
#       'Done'
#     end
#   else
#     'Try again later.'
#   end
# end

# # TODO: This function sucks and should be refactored
# def parse_rust_message(message, bot)
#   message_parsed = JSON.parse(message)['Message']
#   if message_parsed.include?('has entered the game')
#     parsed_message = message_parsed.gsub!(/\[.*\]/, '')
#     @rust_channel.send_message(parsed_message) if @rust_channel.history(1).first.content != parsed_message
#     # redis = Redis.new(host: ENV['REDIS'])
#     # redis.publish('RustCommands', parsed_message)
#     # redis.close
#   end
#   puts message_parsed
# end

# # TODO: shouldn't have to pass reference to @bot in the method
# def announce_message(channel, message, bot)
#   # TODO: array.select is kinda like a foreach.. slow as balls
#   @bot.servers.dig(ENV['EGEEIO_SERVER'].to_i).text_channels.select do |channel|
#     channel.name == channel
#   end.first.send_message(message)
# end

# EM.run do
#   puts 'ws://' + ENV['RUST_IP'] + ':28016/' + ENV['RUST_PASSWORD'] # Debugging because Docker networking is a nightmare
#   ws = Faye::WebSocket::Client.new('ws://' + ENV['RUST_IP'] + ':28016/' + ENV['RUST_PASSWORD'])
#   ws.on :open do
#     puts 'Connected to Rust WebSocket.'
#     # ws.send("{Message: 'say hello, again!', Type: 'Command'}")
#   end
#   ws.on :message do |event|
#     parse_rust_message(event.data, @bot)
#   end
#   ws.on :close do |code, reason|
#     puts "WebSocket closed: #{code} #{reason}"
#   end
#   ws.on :error do |event|
#     puts 'wrcon connection errored out: ' + event.data
#   end
# end
