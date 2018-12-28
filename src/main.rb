test = require './listen'

unless ENV['TOKEN']
  raise('Exiting - Double check your environment variables.')
end

Listen.new
