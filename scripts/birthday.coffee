module.exports = (robot) ->
  robot.respond /When is your birthday\?/i, (res) ->
    res.send "I was born on the 11th May 2015."
