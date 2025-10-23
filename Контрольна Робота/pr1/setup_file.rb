# Створюємо тестовий файл
File.open('test.log', 'w') do |f|
  (1..22).each do |i|
    f.puts("Це рядок номер #{i}")
  end
end
puts "Створено 'test.log' з 22 рядками."