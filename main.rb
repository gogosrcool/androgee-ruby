# frozen_string_literal: true

require('./connection_factory.rb')
require('./discord_events.rb')
require('./rust_events.rb')
require('./helpers.rb')

# The object that does it all!
class Androgee
  def initialize
    json = JSON.parse(File.read('blob.json'))
    connection_factory = ConnectionFactory.new
    bot = connection_factory.discord_connection
    helpers = Helpers.new(bot)
    bot.ready do
      puts 'Connected to Discord Server'
      bot.game = json['games'].sample
      DiscordEvents.new(bot)
      RustEvents.new(connection_factory, helpers)
    end
    bot.run
  end
end

Androgee.new

# bot.command :rust do |event|
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
