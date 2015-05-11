module.exports = (robot) ->
  robot.respond /When is your birthday\?/i, (res) ->
    res.send "I was born on May 11th, 2015."
