require 'rest-client'
require 'discordrb'
require 'json'
require 'rcon'

file = File.read('blob.json')
json = JSON.parse(file)
bot = Discordrb::Bot.new token: ENV['RBBY']

bot.ready do
  bot.game = json['games'].sample
end

bot.member_join do |event|
  event.server.default_channel.send_message event.user.display_name + ' has joined! :metal:'
end

bot.member_leave do |event|
  event.server.channels_by_id[ENV['DEBUG_CHANNEL']].send_message event.user.display_name + ' just left the server!'
end

bot.message do |event|
  event.respond(message_engine(event.content)) if event.content[0] == '~'
end

def message_engine(message)
  case message
  when '~fortune'
    '``' + `fortune -s | cowsay` + '``'
  when '~catpic'
    RestClient.get('http://thecatapi.com/api/images/get?format=src&type=jpg').request.url
  when '~catgif'
    RestClient.get('http://thecatapi.com/api/images/get?format=src&type=gif').request.url
  when '~chucknorris'
    JSON.parse(RestClient.get('http://api.icndb.com/jokes/random?exclude=[explicit]'))['value']['joke']
  when '~ghostbusters'
    '``' + `cowsay -f ghostbusters Who you Gonna Call` + '``'
  when '~moo'
    '``' + `apt-get moo` + '``'
  else
    if message.include?('~minecraft time')
      minecraft_command(message)
    else
      "I don't know that command. 😞"
    end
  end
end

def minecraft_command(message)
  rcon = RCon::Query::Minecraft.new(ENV['MINECRAFT_IP'], ENV['MINECRAFT_PORT'])
  rcon.auth(ENV['MINECRAFT_PASSWORD'])
  rcon.command('time set 0') if message.include?('day')
  rcon.command('time set 12000') if message.include?('night')
  rcon.disconnect
  if rcon.authed == false
    'Minecraft server time changed :ok_hand:'
  else
    'Something got jacked up while setting the time in Minecraft :thumbsdown:'
  end
end

bot.run
