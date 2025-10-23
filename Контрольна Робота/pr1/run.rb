require_relative 'file_batch_enumerator'

iterator = FileBatchEnumerator.new('test.log', 5)

# --- 1. Внутрішній ітератор (з блоком) ---
puts "--- Внутрішній ітератор ---"
iterator.each do |batch|
  puts "Отримано батч: #{batch.size} рядків"
end

# --- 2. Зовнішній ітератор (ручне керування) ---
puts "\n--- Зовнішній ітератор ---"
external_iter = iterator.each # Отримуємо сам ітератор
begin
  puts "Беремо 1-й батч: #{external_iter.next.size} рядків"
  puts "Беремо 2-й батч: #{external_iter.next.size} рядків"
rescue StopIteration
  puts "Ітератор завершився."
end

# --- 3. Методи з Enumerable ---
puts "\n--- Enumerable методи ---"
puts "Перший батч: #{iterator.first.inspect}"