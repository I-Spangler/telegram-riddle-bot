require 'telegram/bot'

token = '318308389:AAE4smaQ8529Ol2XjonSdO9LUvTMs-EFAzk'

Telegram::Bot::Client.run(token) do |bot|
  $riddle = {}
  write = false
  $counter = {}
  $users = []
  off = true
  $limit = 100000000000

  bot.listen do |message|
    if message.text.nil?
    else
      cmd = message.text

      if write == true
        $riddle[message.from.id] = message.text
        write = false
      end
      if $counter[message.from.id] == $limit
          bot.api.send_message(chat_id: message.chat.id, text: "You took too long, you lose.")
          $counter = {}
      end
      puts "message from: #{message.from.first_name} text: #{message.text}"
      case cmd
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "The game is on, #{message.from.last_name}")
          off = false
          $users << message.from.last_name
          $counter[message.from.id] = 0
        when '/help'
          bot.api.send_message(chat_id: message.chat.id, text: "/start to start the game,
          /new for new puzzle, /rules for the rules,
          /remember to display the current puzzle again,
          /score to see the actual score
          /win for when you guys win
          /lose for when you guys lose
          /help to show this help")
        when '/rules'
          bot.api.send_message(chat_id: message.chat.id, text: "Messages ended with a '?' are counted. Other messages are not.")
        when '/new'
          bot.api.send_message(chat_id: message.chat.id, text: "Today's case is:")
          write = true
        when '/remember'
          bot.api.send_message(chat_id: message.chat.id, text: "\"#{$riddle[message.from.id]}\"")
        when '/win'
          bot.api.send_message(chat_id: message.chat.id, text: "Elementary, my dear #{$users}")
          $counter = {}
          off = true
        when '/lose'
          bot.api.send_message(chat_id: message.chat.id, text: "You lose.")
          $counter = {}
          off = true
        when '/score'
          bot.api.send_message(chat_id: message.chat.id, text: "Questions asked: #{$counter[message.from.id]}")
        when '/setlimit'
          $limit = cmd[1]
          puts "#{$limit}"
        else
          if message.text[-1] == "?" and $counter[message.from.id] and off == false
            $counter[message.from.id] += 1
          end
      end
    end
  end
end
