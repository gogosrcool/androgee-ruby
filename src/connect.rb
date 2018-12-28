require 'discordrb'

# Do it
class Connect
  def discord
    Discordrb::Commands::CommandBot.new(token: '', prefix: '|')
  end
end
