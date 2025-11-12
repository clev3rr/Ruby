require 'thread'

module RackMetrics
  class Registry
    # Визначаємо "кошики" для гістограм (у мілісекундах та байтах)
    LATENCY_BUCKETS = [10, 50, 100, 250, 500, 1000, 2500, 5000].freeze
    SIZE_BUCKETS    = [100, 1_024, 10_240, 102_400, 1_048_576].freeze # 100B, 1KB, 10KB, 100KB, 1MB

    def initialize
      @mutex = Mutex.new # Mutex потрібен для потоко-безпечності
      clear
    end

    # Скидає всі лічильники
    def clear
      @mutex.synchronize do
        @requests_total = 0
        @status_codes = Hash.new(0)
        @latency_histogram = (LATENCY_BUCKETS + [:inf]).map { |b| [b, 0] }.to_h
        @size_histogram = (SIZE_BUCKETS + [:inf]).map { |b| [b, 0] }.to_h
      end
    end

    # Головний метод для запису даних
    def record_request(status, duration_ms, response_size)
      @mutex.synchronize do
        @requests_total += 1
        @status_codes[status.to_i / 100] += 1 # Групуємо (2xx, 3xx, 4xx, 5xx)

        # Запис у гістограму латентності
        bucket = LATENCY_BUCKETS.find { |b| duration_ms <= b } || :inf
        @latency_histogram[bucket] += 1

        # Запис у гістограму розміру (ігноруємо відповіді без тіла)
        return if response_size.nil? || response_size.zero?
        bucket = SIZE_BUCKETS.find { |b| response_size <= b } || :inf
        @size_histogram[bucket] += 1
      end
    end

    # Форматуємо вивід для /metrics
    def to_s
      data = ""
      @mutex.synchronize do
        data << "requests_total: #{@requests_total}\n"
        data << "status_codes_2xx: #{@status_codes[2]}\n"
        data << "status_codes_3xx: #{@status_codes[3]}\n"
        data << "status_codes_4xx: #{@status_codes[4]}\n"
        data << "status_codes_5xx: #{@status_codes[5]}\n\n"
        
        data << "# Latency Histogram (ms)\n"
        @latency_histogram.each do |bucket, count|
          data << "latency_le_#{bucket}: #{count}\n"
        end

        data << "\n# Response Size Histogram (bytes)\n"
        @size_histogram.each do |bucket, count|
          data << "size_le_#{bucket}: #{count}\n"
        end
      end
      data
    end
  end
end