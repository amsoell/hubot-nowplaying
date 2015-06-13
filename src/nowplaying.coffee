# Description:
#   Nowplaying queries music services to report what is playing at the moment (and recently)
#
# Dependencies:
#   "xml2js": "0.1.14"
#
# Configuration:
#   None
#
# Commands:
#   hubot what's playing - Find out what's playing on Radio Paradise
#   hubot what played before - Find out what played before the current track on Radio Paradise
xml2js = require "xml2js
module.exports = (robot) ->
  robot.respond /what.*(playing|on the radio|on radio)/i, (msg) ->
    query = encodeURIComponent(msg.match[1])
    msg.http("http://radioparadise.com/xml/now.xml")
      .get() (err, res, body) ->
        if res.statusCode is 200 and !err?
          parser = new xml2js.Parser()
          parser.parseString body, (err, result) ->
            if result.playlist and (result = result.playlist).song?
              if result.song.length?
                song = result.song[0]
              else
                song = result.song
              msg.send "*#{song.title}* by _#{song.artist}_ is currently playing on Radio Paradise: #{song.coverart}"

  robot.respond /what (played|was) before/i, (msg) ->
    query = encodeURIComponent(msg.match[1])
    msg.http("http://radioparadise.com/xml/now_4.xml")
      .get() (err, res, body) ->
        if res.statusCode is 200 and !err?
          parser = new xml2js.Parser()
          i = 0
          parser.parseString body, (err, result)->
            if result.playlist
              for song in result.playlist.song
                if i++>0
                  msg.send "*#{song.title}* by _#{song.artist}_"
