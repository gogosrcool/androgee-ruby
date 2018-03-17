#!/usr/bin/env ruby
# frozen_string_literal: true

Thread.abort_on_exception = true

begin
  require 'dotenv'
  Dotenv.load
rescue LoadError
  puts 'Could not load dotenv, continuing without'
end

require 'discordrb'
require './connections.rb'
require './event_handlers/discord_events.rb'
require './event_handlers/rust_events.rb'
require './event_handlers/minecraft_events.rb'

# The object that does it all!
class Androgee
  def initialize
    bot = Connections.discord_connection

    bot.include! DiscordEvents
    bot.include! RustEvents
    bot.include! MinecraftEvents

    bot.ready do |event|
      event.bot.game = JSON.parse(File.read('blob.json'))['games'].sample
      puts 'Connected to Discord Server'
    end

    bot.run
  end
end

Androgee.new
