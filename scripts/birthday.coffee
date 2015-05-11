module.exports = (robot) ->
  robot.respond /When is your birthday\?/i, (res) ->
    res.send "I was born on the May 11th, 2015."
