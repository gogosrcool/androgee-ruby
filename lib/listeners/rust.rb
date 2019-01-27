require './lib/helpers/discord'
require './lib/helpers/container'

# Comment
module RustListener
  def self.listen(bot)
    channel = DiscordHelpers.discord_channel(bot.servers.dig(ENV['SERVER_ID'].to_i), 'debug')
    player_regex = %r{\/\w+(?=.joined)}
    container = Container.get_container(ENV['RUST_NAME'])
    DiscordHelpers.game_announce(container, player_regex, channel)
  end
end
