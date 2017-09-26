require 'rest-client'
require 'discordrb'
require 'json'

file = File.read('blob.json')
json = JSON.parse(file)
bot = Discordrb::Bot.new token: ENV['RBBY']

bot.ready do
  bot.game = json['games'].sample
end

bot.member_join do |event|
end

bot.member_leave do |event|
end

bot.message do |event|
  if event.content.include? '-'
    event.respond(message_engine(event.content))
  end
end

def message_engine(message)
  case message
  when '-ping'
    'pong'
  when '-fortune'
    'Not Implemented'
  when '-catpic'
    RestClient.get('http://thecatapi.com/api/images/get?format=src&type=jpg').request.url
  when '-catgif'
    RestClient.get('http://thecatapi.com/api/images/get?format=src&type=gif').request.url
  when '-chucknorris'
    JSON.parse(RestClient.get('http://api.icndb.com/jokes/random?exclude=[explicit]'))['value']['joke']
  when '-help'
    'Not Implemented'
  when '-commands'
    'Not Implemented'
  when '-ghostbusters'
    'Not Implemented'
  else
    'Nothing matched, still Not Implemented'
  end
end

bot.run
