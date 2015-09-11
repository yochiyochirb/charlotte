# Description:
#   Tells yochiyochi.rb's published events on Doorkeeper
#
# Commands:
#   hubot event(s) - Tells published events for yochiyochi.rb

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
      num += ""
      num = "0" + num if num.length == 1
      num
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
      # ":couple: #{@participants}/#{@ticket_limit} (キャンセル待ち #{@waitlisted}人)",
      @url,
      ""
    ].join("\n")

module.exports = (robot) ->
  robot.respond /events?$/i, (msg) ->
    response = ":hatching_chick: :baby_chick: よちよち.rb の公開中のイベント :hatching_chick: :baby_chick:\n\n"
    rp = require('request-promise')
    rp("http://api.doorkeeper.jp/groups/yochiyochirb/events")
    .then (body) ->
      response += Event.parse(body)
      response += "\n:beers: :beer: よちよち.beer の公開中のイベント :beers: :beer:\n\n"
      rp("http://api.doorkeeper.jp/groups/yochiyochibeer/events")
      .then (body) ->
        response += Event.parse(body)
        msg.send response
      .catch ->
        msg.send "データ取得エラー (yochiyochibeer) :cry:\n"
    .catch ->
      msg.send "データ取得エラー (yochiyochirb) :cry:\n"
