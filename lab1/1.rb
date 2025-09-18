def lab1_game
  secret = rand(1..100)      # комп'ютер загадує число
  attempts = 0               # лічильник спроб

  puts "Я загадав число від 1 до 100. Спробуй вгадати!"

  loop do # основний цикл гри
    print "Введіть число: "
    guess = gets.to_i
    attempts += 1

    if guess < secret # якщо число менше загаданого
      puts "Більше"
    elsif guess > secret # якщо число більше загаданого
      puts "Менше"
    else
      puts "Вгадано!" 
      puts "Кількість спроб: #{attempts}"
      break
    end
  end
end

# Запуск гри
lab1_game
