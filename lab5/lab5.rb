def curry3(proc_or_lambda)                        # оголошення функції curry3, приймає proc або lambda
  currier = ->(*collected_args) {                 # створюємо лямбду currier, яка зберігає вже зібрані аргументи
    ->(*new_args) {                               # повертається нова лямбда, що приймає додаткові аргументи
      all_args = collected_args + new_args        # об'єднуємо вже зібрані і що щойно прийшли аргументи

      case all_args.length                        # перевіряємо, скільки аргументів наразі зібрано
      when 0...3                                  # якщо менше 3 аргументів
        currier.call(*all_args)                   # повертаємо лямбду, що чекає решти аргументів
      when 3                                      # якщо рівно 3 аргументи
        proc_or_lambda.call(*all_args)            # викликаємо оригінальну лямбду з цими аргументами
      else                                        # якщо аргументів більше ніж 3
        proc_or_lambda.call(*all_args)            # передаємо їх далі — оригінал сам кинеть помилку
      end
    }
  }

  currier.call()                                  # початковий виклик currier без аргументів
end

sum3 = ->(a, b, c) { a + b + c }                  # проста лямбда sum3, що складає три числа
cur = curry3(sum3)                                # створюємо карріровану версію sum3

puts "--- Тести curry3(sum3) ---"                 # заголовок для тестів у консолі
puts "cur.call(1).call(2).call(3) = #{cur.call(1).call(2).call(3)}"   # тест: по одному аргументу → 6
puts "cur.call(1, 2).call(3)      = #{cur.call(1, 2).call(3)}"        # тест: два + один → 6
puts "cur.call(1).call(2, 3)      = #{cur.call(1).call(2, 3)}"        # тест: один + два → 6
puts "cur.call(1, 2, 3)           = #{cur.call(1, 2, 3)}"             # тест: всі три відразу → 6

begin
  cur.call(1, 2, 3, 4)                             # тест: передано забагато аргументів
rescue ArgumentError                               # ловимо стандартну помилку аргументів
  puts "cur.call(1, 2, 3, 4)       = ArgumentError (забагато аргументів)"  # повідомлення про помилку
end

f  = ->(a, b, c) { "#{a}-#{b}-#{c}" }              # інша лямбда для демонстрації на рядках
cF = curry3(f)                                     # її каррірована версія

puts "cF.call('A').call('B','C') = #{cF.call('A').call('B', 'C')}"  # результат → "A-B-C"
