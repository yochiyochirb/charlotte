# Description:
#   Tells yochiyochi.rb's published events on Doorkeeper
#
# Commands:
#   hubot event(s) - Tells published events for yochiyochi.rb

rp = require("request-promise")
Bluebird = require("bluebird");

GROUPS = [
  {
    url: "http://api.doorkeeper.jp/groups/yochiyochirb/events",
    header: ":hatching_chick: :baby_chick: よちよち.rb の公開中のイベント :hatching_chick: :baby_chick:"
  },
  {
    url: "http://api.doorkeeper.jp/groups/yochiyochibeer/events",
    header: ":beers: :beer: よちよち.beer の公開中のイベント :beers: :beer:"
  }
]

class Event
  constructor: (args) ->
    @title = args.title
    @starts_at = Event.formatDate(args.starts_at)
    @ends_at = Event.formatDate(args.ends_at)
    @venue_name = args.venue_name
    @ticket_limit = args.ticket_limit
    @participants = args.participants
    @waitlisted = args.waitlisted
    @url = args.public_url

  @formatDate: (dateString) ->
    zeroPadding = (num) ->
      ("0" + num).slice(-2)
    date = new Date(dateString)
    "#{date.getFullYear()}年#{zeroPadding(date.getMonth() + 1)}月#{zeroPadding(date.getDate())}日" +
    " #{zeroPadding(date.getHours())}:#{zeroPadding(date.getMinutes())}"

  @parse: (body) ->
    content = ""
    data = JSON.parse(body)
    if data.length
      for item in data
        event = new Event(item.event)
        content += event.response() + "\n"
    else
      content += "公開中のイベントはありません :ghost:\n"
    content

  response: ->
    [
      ":star2: #{@title}",
      ":calendar: #{@starts_at}",
      ":earth_asia: #{@venue_name}",
      ":couple: #{@participants}/#{@ticket_limit} (キャンセル待ち #{@waitlisted}人)",
      @url,
      ""
    ].join("\n")

module.exports = (robot) ->
  robot.respond /events?$/i, (msg) ->
    Bluebird.all(rp(group.url) for group in GROUPS)
      .then (results) ->
        response = ""
        for group, index in results
          response += "\n" unless index == 0
          response += GROUPS[index].header
          response += "\n\n"
          response += Event.parse(group)
        msg.send response
      .catch (error) ->
        # robot.logger.error error
        msg.send "データ取得エラー :cry:\n"
