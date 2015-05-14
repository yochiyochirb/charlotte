# Description:
#   Answer Charlotte's birthday.
#
# Commands:
#   hubot When is your birthday? - Returns her birthday.
module.exports = (robot) ->
  robot.respond /When is your birthday\?/i, (res) ->
    res.send "I was born on May 11th, 2015."
