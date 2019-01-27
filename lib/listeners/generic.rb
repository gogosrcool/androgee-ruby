require './lib/helpers/discord'
require './lib/helpers/container'

# Comment
module GenericListener
  def self.listen(bot, game, player_regex)
    channel = DiscordHelpers.discord_channel(bot.servers.dig(ENV['SERVER_ID'].to_i), game)
    container = Container.get_container(ENV["#{game.upcase}_NAME"])
    # if container.state != 'running'
    DiscordHelpers.game_announce(container, player_regex, channel)
    # end
  end
end
