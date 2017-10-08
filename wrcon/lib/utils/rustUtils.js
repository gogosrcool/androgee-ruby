class RustUtils {
  messageOperator (msg, androgee, rustConnection) {
    switch (true) {
      case (msg.message.includes('joined [')):
        const playerName = msg.message.match(/([^/]*)\s*\s/)
        const playerNameNormalized = playerName.pop().trim()
        const discordAnnoucement = playerNameNormalized.replace('joined', 'logged in to')
        const serverAnnoucement = playerName.pop().trim() + ' the server'
        rustConnection.run('say ' + serverAnnoucement)
        break
      case (msg.message.includes('[EAC]')):
        break
      case (msg.message.includes('Hack')):
        break
      case (msg.message.includes('Saving') === false):
        console.log(msg.message + ' - ' + Date.now()) // Saves in Unix time
        break
    }
  }
}

module.exports = RustUtils
