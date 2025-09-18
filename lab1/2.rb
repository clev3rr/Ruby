def lab1_words(text)
  words = text.split # розбиваємо текст на слова
  count = words.size # рахуємо кількість слів
  longest = words.max_by(&:length) # шукаємо найдовше слово
  unique = words.map(&:downcase).uniq.size # рахуємо унікальні слова (ігноруючи регістр)

  puts "#{count} слів, найдовше: #{longest}, унікальних: #{unique}"
end

print "Введи текст: " 
text = gets.chomp # отримуємо текст від користувача
lab1_words(text)
