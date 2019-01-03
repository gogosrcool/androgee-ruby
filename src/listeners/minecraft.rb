require './helpers/discord'
require './helpers/container'

# Comment
class MinecraftListener
  def initialize(discord)
    @discord_helpers = DiscordHelpers.new(discord)
  end

  def listen
    container = Container.get_container('gscminecraft_minecraft-server_1')
    player_regex = /(?<=\bUUID\sof\splayer\s)(\w+)/
    @discord_helpers.game_announce(container, player_regex, 'debug')
  end
end
