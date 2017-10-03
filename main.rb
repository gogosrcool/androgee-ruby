require 'rest-client'
require 'discordrb'
require 'timers'
require 'redis'
require 'json'
require 'rcon'

file = File.read('blob.json')
json = JSON.parse(file)
bot = Discordrb::Bot.new token: ENV['RBBY']
redis = Redis.new

bot.ready do
  bot.game = json['games'].sample
end

redis.subscribe('MinecraftUsers') do |on|
  on.message do |channel, message|
    puts message
  end
end

bot.member_join do |event|
  event.server.default_channel.send_message event.user.display_name + ' has joined! :metal:'
end

bot.member_leave do |event|
  event.server.text_channels.select { |channel| channel.name == 'debug' }.first.send_message event.user.username + ' just left the server!'
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

bot.run
