const WebRcon = require('webrconjs')
const SimpleRcon = require('simple-rcon')

class ConnectionFactory {
  constructor (server) {
    switch (true) {
      case server === undefined:
        break
      case server.includes('moddedMinecraft'):
        return this.getModdedMinecraftConnection()
      case server.includes('minecraft'):
        return this.getMinecraftConnection()
      case server.includes('rust'):
        return this.getRustConnection()
      case server.includes('gmod'):
        return this.getGmodConnection()
      default:
        console.log('Command not found.')
    }
  }
  getRustConnection () {
    const wRcon = new WebRcon(process.env.RUST_IP, process.env.RUST_PORT)
    wRcon.connect(process.env.RUST_PASSWORD)
    return wRcon
  }
  getMinecraftConnection () {
    return new SimpleRcon({
      host: process.env.MINECRAFT_IP,
      port: process.env.MINECRAFT_PORT,
      password: process.env.MINECRAFT_PASSWORD,
      timeout: 10000
    })
  }
  getModdedMinecraftConnection () {
    return new SimpleRcon({
      host: process.env.MODDED_MINECRAFT_IP,
      port: process.env.MODDED_MINECRAFT_PORT,
      password: process.env.MODDED_MINECRAFT_PASSWORD,
      timeout: 10000
    })
  }
  getGmodConnection () {
    return new SimpleRcon({
      host: process.env.GMOD_IP,
      port: process.env.GMOD_PORT,
      password: process.env.GMOD_PASSWORD
    })
  }
}

module.exports = ConnectionFactory
