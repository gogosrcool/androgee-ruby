# frozen_string_literal: true

require 'eventmachine'

# Object that handles events coming from the Rust server
class RustEvents
  def initialize(connection_factory, helpers)
    EM.run do
      @ws = connection_factory.wrcon_connection
      @helpers = helpers
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
      message = JSON.parse(event.data)['Message'] # Sometimes Rust nests json
      message = JSON.parse(message)['Message'] if message.start_with?('{')
      msg = @helpers.process_rust_message(message)
      if msg.is_a?(Hash)
        if msg.key?('debug')
          puts "RUST DEBUG: #{msg['debug']}"
        elsif msg.key?('server')
          @ws.send(msg['server'])
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
