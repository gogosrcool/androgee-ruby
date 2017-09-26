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

bot.message(with_text: '-ping') do |event|
  event.respond 'boogers'
end

bot.run
