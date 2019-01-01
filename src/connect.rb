require 'discordrb'

# Do it
class Connect
  def discord
    Discordrb::Commands::CommandBot.new(token: ENV['TOKEN'], prefix: ENV['PREFIX'])
  end
end
