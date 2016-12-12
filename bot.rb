require 'telegram/bot'

token = '318308389:AAE4smaQ8529Ol2XjonSdO9LUvTMs-EFAzk'

Telegram::Bot::Client.run(token) do |bot|
  $riddle = ""
  write = false
  $counter = {}
  $users = []
  off = true
  $limit = 100000000000

  bot.listen do |message|
  
    cmd = message.text.split()
    if write == true
      $riddle = message.text
      write = false
    end
    if $counter[message.from.id] == $limit
        bot.api.send_message(chat_id: message.chat.id, text: "You lose.")
        $counter = {}
    end
    puts "message from: #{message.from.first_name} text: #{message.text}"
    case cmd[0]
      when '/start'
        bot.api.send_message(chat_id: message.chat.id, text: "Game starts, #{message.from.last_name}")
        off = false
        $users << message.from.last_name
        $counter[message.from.id] = 0
      when '/help'
        bot.api.send_message(chat_id: message.chat.id, text: "/start to start the game,
        /new for new puzzle, /rules for the rules,
        /remember to display the current puzzle again,
        /off to send texts without being counted
        /on to return to the game,
        /score to see the actual score
        /win for when you guys win
        /lose for when you guys lose
        /help to show this help")
      when '/rules'
        bot.api.send_message(chat_id: message.chat.id, text: "There is no rules")
      when '/new'
        bot.api.send_message(chat_id: message.chat.id, text: "Send new riddle")
        write = true
      when '/remember'
        bot.api.send_message(chat_id: message.chat.id, text: "\"#{$riddle}\"")
      when '/win'
        bot.api.send_message(chat_id: message.chat.id, text: "You solved it! Congratulations, #{$users}")
        $counter = {}
        off = true
      when '/lose'
        bot.api.send_message(chat_id: message.chat.id, text: "You lose.")
        $counter = {}
        off = true
      when '/off'
        off = true
      when '/on'
        off = false
      when '/score'
        bot.api.send_message(chat_id: message.chat.id, text: "Questions asked: #{$counter[message.from.id]}")
      when '/setlimit'
        $limit = cmd[1]
        puts "#{$limit}"
      else
        if off == false and $counter != nil
          $counter[message.from.id] += 1
        end
    end
  end
end
