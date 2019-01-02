require 'docker'
require './helpers/discord.rb'

# Comment
class MinecraftListener
  def initialize(discord)
    @get_container = GetContainer.new
    @discord_helpers = DiscordHelpers.new(discord)
  end
  def Listen
    container = @get_container.get_em('gscminecraft_minecraft-server_1')
    player_regex = /(?<=\bUUID\sof\splayer\s)(\w+)/
    @discord_helpers.game_announce(container, player_regex, 'debug')
  end
end
