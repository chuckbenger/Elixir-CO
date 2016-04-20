# Conquer Server

**Path 4267 built using the Elixir Programming Language**

This project aimed to assist me in learning the Elixir language.
The project was structured in multiple sub applications. It currently
emulates the following functionality.

* Logging in
* Jumping around the screen & other various actions
* Sending those updates to all surrounding clients
* Map changing

**game_server**
***
* handles client connection
* decryption/encryption

**map_server**
***
* Handles a map and all of it's sectors
* This OTP application is seperate from the game_server
meaning I can make live updates to the map code without a
client disconnecting

**npc_server**
***
*Handles client interactions with an NPC

**common**
***
* Common code shared among all the other sub applications

**auth_server**
***
* Handles client login attempts


