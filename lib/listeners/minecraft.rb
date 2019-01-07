require './lib/helpers/discord'
require './lib/helpers/container'

# Comment
module MinecraftListener
  def self.listen(bot)
    channel = DiscordHelpers.discord_channel(bot.servers.dig(ENV['SERVER_ID'].to_i), 'debug')
    player_regex = /(?<=\bUUID\sof\splayer\s)(\w+)/
    container = Container.get_container(ENV['MINECRAFT_NAME'])
    DiscordHelpers.game_announce(container, player_regex, channel)
  end
end
