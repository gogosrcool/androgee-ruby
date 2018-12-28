require 'discordrb'

# Do it
class Connect
  def discord
    Discordrb::Commands::CommandBot.new(token: 'NTEwNzIwMzIyMjI4NzE1NTI0.DsgdrQ.MIPET-VFYCUR8oF8wyAzrR_5HZU', prefix: '|')
  end
end
