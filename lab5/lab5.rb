def curry3(proc_or_lambda)                          # Функція приймає лямбду або proc
  currier = ->(*collected_args) {                   # collected_args — уже передані аргументи
     
    ->(*new_args) {                                 # Лямбда, що чекає нових аргументів
      all_args = collected_args + new_args          # Об'єднуємо всі аргументи

      case all_args.length
      when 0...3                                     # < 3 аргументів → чекаємо ще
        currier.call(*all_args)
      when 3                                         # рівно 3 → викликаємо вихідну лямбду
        proc_or_lambda.call(*all_args)
      else                                           # > 3 → нехай вихідна лямбда падає з помилкою
        proc_or_lambda.call(*all_args)
      end
    }
  }

  currier.call()                                    # Початковий стан — немає аргументів
end

# --- Лямбда sum3 ---
sum3 = ->(a, b, c) { a + b + c }
cur = curry3(sum3)

puts "--- Тести curry3(sum3) ---"

puts "cur.call(1).call(2).call(3) = #{cur.call(1).call(2).call(3)}"
puts "cur.call(1, 2).call(3)      = #{cur.call(1, 2).call(3)}"
puts "cur.call(1).call(2, 3)      = #{cur.call(1).call(2, 3)}"
puts "cur.call(1, 2, 3)           = #{cur.call(1, 2, 3)}"
puts "cur.call().call(1, 2, 3)    = #{cur.call().call(1, 2, 3)}"

# --- Перевірка ArgumentError ---
begin
  cur.call(1, 2, 3, 4)
rescue ArgumentError
  puts "cur.call(1, 2, 3, 4)       = ArgumentError (забагато аргументів)"
end

# --- Інша лямбда ---
f  = ->(a, b, c) { "#{a}-#{b}-#{c}" }
cF = curry3(f)

puts "cF.call('A').call('B','C') = #{cF.call('A').call('B', 'C')}"
