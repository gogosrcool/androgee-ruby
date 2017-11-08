require 'faye/websocket'
require 'eventmachine'
require 'rest-client'
require 'discordrb'
require 'redis'
require 'json'

$rust_channel = nil
file = File.read('blob.json')
json = JSON.parse(file)
bot = Discordrb::Commands::CommandBot.new token: ENV['RBBY'], prefix: '~'

bot.ready do
  $rust_channel = bot.servers.dig(ENV['EGEEIO_SERVER'].to_i).text_channels.select do |channel|
    channel.name == 'rust-server'
  end.first
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
    puts 'ws://' + ENV['RUST_IP'] + ':28016/' + ENV['RUST_PASSWORD'] # Debugging because Docker networking is a nightmare
    ws = Faye::WebSocket::Client.new('ws://' + ENV['RUST_IP'] + ':28016/' + ENV['RUST_PASSWORD'])
    ws.on :connect do |event|
      puts 'wrcon connected!'
    end
    ws.on :message do |event|
      parse_rust_message(event.data, bot)
      # ws.send('say Hello Folks') # This causes the entire connection to error out
    end
    ws.on :disconnect do |event|
      puts 'wrcon disconnected'
    end
    ws.on :error do |event|
      puts 'wrcon connection errored out: ' + event.data
    end
  end
end

# TODO: Remove redundant chat message logs
def parse_rust_message(message, bot)
  message_parsed = JSON.parse(message)['Message']
  if message_parsed.include?('has entered the game')
    parsed_message = message_parsed.gsub!(/\[.*\]/, '')
    $rust_channel.send_message(parsed_message) if $rust_channel.history(1).first.content != parsed_message
    redis = Redis.new(host: 'localhost')
    redis.publish('RustCommands', parsed_message)
    redis.close
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
