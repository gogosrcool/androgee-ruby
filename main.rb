require 'faye/websocket'
require 'eventmachine'
require 'rest-client'
require 'discordrb'
require 'redis'
require 'json'

file = File.read('blob.json')
json = JSON.parse(file)
bot = Discordrb::Commands::CommandBot.new token: ENV['RBBY'], prefix: '~'

bot.ready do
  bot.game = json['games'].sample
end

bot.member_join do |event|
  event.server.default_channel.send_message event.user.display_name + ' has joined! :wave:'
end

bot.member_leave do |event|
  event.server.text_channels.select do |channel|
    channel.name == 'debug'
  end.first.send_message event.user.username + ' just left the server!'
end

bot.command :fortune do
  '``' + `fortune -s | cowsay` + '``'
end

bot.command :translate do |event|
  test = event.message.content.slice(11..event.message.content.length)
  RestClient.post 'http://api.funtranslations.com/translate/jive.json', text: test do |response, request, result|
    if result.code == '429'
      JSON.parse(result.body).dig('error', 'message')
    else
      JSON.parse(response.body).dig('contents', 'translated')
    end
  end
end

bot.command :catpic do
  RestClient.get('http://thecatapi.com/api/images/get?format=src&type=jpg').request.url
end

bot.command :catgif do
  RestClient.get('http://thecatapi.com/api/images/get?format=src&type=gif').request.url
end

bot.command :chucknorris do
  JSON.parse(RestClient.get('http://api.icndb.com/jokes/random?exclude=[explicit]'))['value']['joke']
end

bot.command :ghostbusters do
  '``' + `cowsay -f ghostbusters Who you Gonna Call` + '``'
end

bot.command :moo do
  '``' + `apt-get moo` + '``'
end

bot.command :rust do |event|
  if event.message.content.include?('time')
    redis = Redis.new(host: 'localhost')
    redis.publish('RustCommands', event.message.content)
    redis.close
  end
  'done'
end

Thread.new do
  EM.run do
    ws = Faye::WebSocket::Client.new('ws://' + ENV['RUST_IP'] + ':28016/' + ENV['RUST_PASSWORD'])
    ws.on :connect do |event|
      puts 'wrcon connected!'
    end
    ws.on :message do |event|
      parse_rust_message(event.data, bot)
      #ws.send('say Hello Folks') # This causes the entire connection to error out
    end
    ws.on :disconnect do |event|
      puts 'wrcon disconnected'
    end
    ws.on :error do |event|
      puts 'wrcon connection errored out'
    end
  end
end

Thread.new do
  redis = Redis.new(host: 'localhost')
  redis.subscribe('RustPlayers') do |on|
    puts 'subscribed to RustPlayers'
    on.message do |_channel, message|
      puts message
      announce_message 'rust-server', message, bot
    end
  end
end

# TODO: Remove redundant chat message logs
def parse_rust_message(message, bot)
  message_parsed = JSON.parse(message)['Message']
  if (message_parsed.include?('has entered the game'))
    bot.servers.dig(ENV['EGEEIO_SERVER'].to_i).text_channels.select do |channel|
      channel.name == 'rust-server'
    end.first.send_message(message_parsed.gsub!(/\[.*\]/, ''))
  end
  puts message_parsed
end

# TODO: shouldn't have to pass reference to bot in the method
def announce_message(channel, message, bot)
  # TODO: array.select is kinda like a foreach.. slow as balls
  bot.servers.dig(ENV['EGEEIO_SERVER'].to_i).text_channels.select do |channel|
    channel.name == channel
  end.first.send_message(message)
end

bot.run
