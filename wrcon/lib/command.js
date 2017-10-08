const ConnectionFactory = require('./factories/connectionFactory.js')

class Command {
  constructor (server, webrcon) {
    if (server.socket === undefined) {
      this.connection = new ConnectionFactory(server)
    } else if (server.socket !== null) {
      // Have wrcon.run do its thing here instead of inside the command factory
    } else {
      console.log('Reference to Rust server was null.')
    }
  }
  exec (command) {
    return new Promise((resolve, reject) => {
      this.connection.exec(command, (response) => {
        resolve(response)
      }).connect()
      this.connection.on('error', (err) => {
        console.log(err)
      })
    })
  }
}

module.exports = Command
