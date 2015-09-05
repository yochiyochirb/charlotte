# Description:
#   Send a message when becomes the scheduled time.
#
# Commands:
#   hubot remind 07:00 Good morning! - Send "Good morning!" at 7:00

scheduler = require('node-schedule')

module.exports = (robot) ->
  robot.respond /remind (\d+):(\d+) (.*)/i, (msg) ->
    remind robot, msg, msg.match[1], msg.match[2], msg.match[3]

remind = (robot, msg, hour, minute, message) ->
  try
    currentDate = new Date()
    currentYear = currentDate.getFullYear()
    currentMonth = currentDate.getMonth()
    currentDay = currentDate.getDay() - 1
    scheduleDate = new Date(currentYear, currentMonth, currentDay, hour, minute)
    new scheduler.scheduleJob scheduleDate, =>
      msg.send message
    msg.send "#{scheduleDate} \"#{message}\", sure."
  catch error
    msg.send error
