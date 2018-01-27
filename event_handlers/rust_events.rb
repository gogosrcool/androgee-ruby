# frozen_string_literal: true

require 'eventmachine'
require './helpers/rust_helpers'

# Object that handles events coming from the Rust server
class RustEvents
  def initialize(connection_factory, helpers)
    EM.run do
      @ws = connection_factory.wrcon_connection
      @helpers = helpers
      @rust_helpers = RustHelpers.new(@helpers)
      @rust_channel = @helpers.get_discord_channel('rust-server')
      open
      message
      close
      error
    end
  end

  def open
    @ws.on :open do
      puts 'Connected to Rust WebSocket.'
    end
  end

  def message
    @ws.on :message do |event|
      msg = @rust_helpers.process_message(event)
      next if msg.is_a?(Hash) == false
      p "RUST: #{msg}"
      if msg.key?('COMMAND')
        @ws.send(msg['COMMAND']) if @helpers.check_last_message(@rust_channel, msg['COMMAND']) == false
      elsif msg.key?('SERVER')
        if @helpers.check_last_message(@rust_channel, msg['SERVER']) == false
          @rust_channel.send_message(@rust_helpers.rust_server_message(msg['SERVER']))
        end
      end
    end
  end

  def close
    @ws.on :close do |code, reason|
      @helpers.debug_notification("**Rust Server** - #{code} #{reason}")
    end
  end

  def error
    @ws.on :error do |event|
      @helpers.debug_notification("**Rust Server** - #{event.message}")
    end
  end
end
