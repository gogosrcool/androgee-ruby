require './listen'

raise('Exiting - Double check your environment variables.') unless ENV['TOKEN']

Listen.new
