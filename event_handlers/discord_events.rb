# frozen_string_literal: true

# The object that contains and handles all events associated with Discord
class DiscordEvents
  def initialize(discord, connection_factory, helpers)
    @connection_factory = connection_factory
    @helpers = helpers
    @discord = discord
    fun_messages
    server_events
    general_messages
    game_messages
  end

  def game_messages
    @discord.command :minecraft_list do
      rcon = @connection_factory.rcon_connection
      players = rcon.command('list').slice!(30..-1)
      rcon.disconnect

      current_players = players.split(/\s*,\s*/).sort
      normalized = current_players.to_s.chop![1..-1].gsub('"','')
      @helpers.get_discord_channel('minecraft-server').send_message("The following players are online: #{normalized}")
    end
  end

  # Server event handler
  def server_events
    @discord.member_join do |event|
      event.server.default_channel.send_message event.user.display_name + ' has joined! :wave:'
    end
    @discord.member_leave do |event|
      event.server.text_channels.select do |channel|
        channel.name == 'debug'
      end.first.send_message event.user.username + ' just left the server.'
    end
  end

  # General message event handler
  def general_messages
    @discord.command :help do
      "Mrj programmed me with the following commands:\n
      ~assign_role\n
      ~fortune\n
      ~chucknorris\n
      ~ghostbusters\n
      ~moo\n
      ~translate\n
      ~catpic\n
      ~catgif"
    end
    @discord.command :assign_role do |event|
      json = JSON.parse(File.read('blob.json'))
      role = event.message.content[13..-1]

      json['protected_roles'].each do |r|
        role = 'invalid' if r.include?(role)
      end
      event.server.roles.each do |r|
        if r.name.include?(role)
          event.author.add_role(r)
          role = 'valid'
        end
      end
      if role == 'invalid'
        'Invalid role. Try something else.'
      elsif role == 'valid'
        'Done'
      else
        'Nope.'
      end
    end
  end

  # Fun message event handler
  def fun_messages
    @discord.command :fortune do
      '``' + `fortune -s | cowsay` + '``'
    end
    @discord.command :chucknorris do
      JSON.parse(RestClient.get('http://api.icndb.com/jokes/random?exclude=[explicit]'))['value']['joke']
    end
    @discord.command :ghostbusters do
      '``' + `cowsay -f ghostbusters Who you Gonna Call` + '``'
    end
    @discord.command :moo do
      '``' + `apt-get moo` + '``'
    end
    @discord.command :translate do |event|
      @helpers.delete_last_message(event.channel)
      test = event.message.content.slice(11..event.message.content.length)
      RestClient.post 'http://api.funtranslations.com/translate/jive.json', text: test do |response, request, result|
        if result.code == '429'
          JSON.parse(result.body).dig('error', 'message')
        else
          JSON.parse(response.body).dig('contents', 'translated')
        end
      end
    end
    @discord.command :catpic do
      RestClient.get('http://thecatapi.com/api/images/get?format=src&type=jpg').request.url
    end

    @discord.command :catgif do
      RestClient.get('http://thecatapi.com/api/images/get?format=src&type=gif').request.url
    end
  end
end
