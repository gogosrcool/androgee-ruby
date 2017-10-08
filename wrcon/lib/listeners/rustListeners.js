const Redis = require('redis')

class RustListeners {
  constructor (rustConnection, androgee) {
    this.wRcon = rustConnection
    rustConnection.on('connect', function () {
      console.log('CONNECTED TO RUST SERVER')
    })
    rustConnection.on('disconnect', function () {
      console.log('DISCONNECTED FROM RUST SERVER')
      androgee.connectRust()
    })
    rustConnection.on('message', function (msg) {
      try {
        if (msg.message.includes('joined [')) {
          const redis = Redis.createClient({host: 'redis'})
          const playerName = msg.message.match(/([^/]*)\s*\s/)
          const playerNameNormalized = playerName.pop().trim()
          const discordAnnoucement = playerNameNormalized.replace('joined', 'logged in to')
          const serverAnnoucement = playerName.pop().trim() + ' the server'
          rustConnection.run('say ' + serverAnnoucement)
          redis.publish('RustPlayers', discordAnnoucement + ' the Rust server')
        } else if (msg.message.includes('Saving') === false) {
          console.log(msg.message + ' - ' + Date.now()) // add moment.js for this
        }
      } catch (err) {
        console.log('Something in the Rust message listener failed: ' + err)
      }
    })
    rustConnection.on('error', function (err) {
      console.log('ERROR:', err)
    })
  }
  help (message) {
    message.reply('Current options are: **time**')
  }
  kick (message) {
    let username = message.content.substring(11, message.content.length)
    if (username !== '') {
      this.wRcon.run('kick ' + username)
      message.reply('just kicked ' + username + ' from the server.')
    }
  }
  ban (message) {
    let username = message.content.substring(10, message.content.length)
    if (username !== '') {
      this.wRcon.run('ban ' + username)
      message.reply('just ban ' + username + ' from the server.')
    }
  }
  teleport (message) {
    const usernames = message.content.substring(15, message.content.length)
    if (usernames !== '') {
      const username01 = usernames.match(/^[^\s]+/)
      const username02 = usernames.match(/(\w+)$/)
      this.wRcon.run('teleport ' + username01 + ' ' + username02[0])
      this.wRcon.run('say ' + message.author.username + ' just teleported ' + username01 + ' to ' + username02[0] + ' from the Discord server')
      message.reply('just teleported ' + username01 + ' to ' + username02[0])
    }
  }
  setTime (message) {
    const msg = message.author.username + ' just set the time to '
    if (message.content.includes('day')) {
      const msgDay = msg + 'day'
      this.wRcon.run('env.time 9')
      this.wRcon.run('say ' + msgDay + ' from the Discord server')
      message.reply('setting time to day...')
    } else if (message.content.includes('night')) {
      const msgNight = msg + 'night'
      this.wRcon.run('env.time 23')
      this.wRcon.run('say ' + msgNight)
      message.reply('setting time to night...')
    }
  }
}

module.exports = RustListeners
