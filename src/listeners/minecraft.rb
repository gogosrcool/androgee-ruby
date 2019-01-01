require 'docker'

# Comment
class MinecraftListener
  def lol
    test = GetContainer.new
    test2 = test.get_em('gscrust_rust-server_1')
    # player_regex = /(?<=\bUUID\sof\splayer\s)(\w+)/

    thirty = Time.now.to_i - 30

    logs = test2.logs(stdout: true, since: thirty)
    puts logs
  end
end
