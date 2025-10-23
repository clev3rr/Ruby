# file_batch_enumerator.rb

class FileBatchEnumerator
  # 1. Підключаємо Enumerable для отримання .map, .first, .select тощо.
  include Enumerable

  def initialize(file_path, batch_size)
    @file_path = file_path
    @batch_size = batch_size

    # (Тут мають бути перевірки на існування файлу та batch_size > 0)
    unless File.exist?(@file_path)
      raise ArgumentError, "Файл не знайдено: #{@file_path}"
    end
    unless @batch_size.is_a?(Integer) && @batch_size > 0
      raise ArgumentError, "Розмір батчу (N) має бути цілим числом > 0"
    end
  end

  # 2. Реалізуємо контрактний метод .each
  def each
    # 3. Це робить його ЗОВНІШНІМ ітератором
    return to_enum(:each) unless block_given?
    
    batch = [] # Тимчасове сховище
    
    # 4. Безпечно відкриваємо файл
    File.open(@file_path, 'r') do |file|
      
      # 5. Читаємо по рядку, НЕ завантажуючи весь файл у пам'ять
      file.each_line do |line|
        batch << line.chomp # .chomp прибирає символ \n
        
        # 6. Коли батч повний, віддаємо його
        if batch.size >= @batch_size
          yield batch
          batch = [] # Готуємо новий батч
        end
      end
    end
    
    # 7. Віддаємо залишки (якщо вони є)
    yield batch unless batch.empty?
  end
end