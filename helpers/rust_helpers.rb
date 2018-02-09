# frozen_string_literal: true

# Methods for performaning actions for the Rust server
class RustHelpers
  def initialize(helpers)
    # TODO: Not the greatest name... which helper is this?
    @helpers = helpers
  end

  def process_message(event)
    msg = process_rust_json(event)
    if msg['DEBUG'].to_s.include?('has entered the game')
      return rust_player_join(msg)
    elsif msg['DEBUG'].to_s.include?('used *kill* on ent:')
      { 'SERVER' => msg['DEBUG'].to_s }
    elsif msg['COMMAND']
      return validate_command(msg)
    else
      return msg
    end
  end

  def validate_command(msg)
    return if msg['Egee'].nil?
    command = msg['Egee']
    command[0] = ''
    { 'COMMAND' => "{Message: '#{command}', Type: 'Command'}" }
    # TODO: It would be nice to have alias for all players to use
    # if things == 'time day'
    #   { 'COMMAND' => "{Message: 'env.time 11', Type: 'Command'}" }
    # elsif things == 'time night'
    #   { 'COMMAND' => "{Message: 'env.time 23', Type: 'Command'}" }
    # elsif things.include?('teleport')
    #   { 'COMMAND' => "{Message: '#{things}', Type: 'Command'}" }
    # end
  end

  def process_rust_json(event)
    message = JSON.parse(event.data)['Message']
    if message.start_with?('{')
      msg = JSON.parse(message)['Message']
      message = { JSON.parse(message)['Username'] => msg }
      message['COMMAND'] = msg if message.first.to_s.include? '~'
    else
      message = { 'DEBUG' => message }
    end
    filter_rust_messages(message)
  end

  def rust_player_join(message)
    parsed_message = message['DEBUG'].to_s.gsub!(/\[.*\]/, '')
    normalized = parsed_message.sub('entered the game', 'joined')
    { 'COMMAND' => "{Message: 'say #{normalized}', Type: 'Command'}" }
  end

  def filter_rust_messages(message)
    message = '' if message['DEBUG'].to_s.include?('totalstall(')
    message = '' if message['DEBUG'].to_s.include?('Saving complete')
    message = '' if message['DEBUG'].to_s.include?('[Manifest]')
    message
  end

  def rust_server_message(msg)
    "``#{msg}``"
  end
end
