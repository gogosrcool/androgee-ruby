# Androgee
Androgee is a ~~super-simple~~ Discord bot written in [NodeJS](https://nodejs.org/en/) and [DiscordJS](https://discord.js.org/).

# Purpose
Androgee was originally designed to be an replacement for BooBot in the Egee.io Discord server. Androgee later extended to perform administration over the Egee.io game servers.

Androgee's current feature set includes:

Dicord Admin Stuff: 
* Announcing when a member has _joined_ the server
* Announcing when a member has _left_ the server
* Announcing when a member has been banned

Game Server Admin Stuff:
* Kicking a player
* Banning a player
* Setting time to day or night
* Teleporting players
* Speaking to players
* Setting weather on Minecraft
* Calling helicopter on Rust

Fun Stuff:
* Showing cat pics and gifs
* Printing Chuck Norris quotes
* Printing Cowsay quotes
* Printing Fortune quotes

# Architecture 
Egee-bot is written using [ES6](https://developer.mozilla.org/en-US/docs/Web/JavaScript/New_in_JavaScript/ECMAScript_6_support_in_Mozilla) JavaScript, and the [DiscordJS](https://github.com/hydrabolt/discord.js/) Node module. All Discord-related IDs are pulled from environment variables.

Hooks into game servers use Rcon or Webhooks, depending on the game.

# License
Androgee is licensed under MIT so that the core functionality of the bot remains open source and free for everyone but any code you write (including server and room IDs for example) for your own Discord servers doesn't have to be.
