require 'rack_metrics/registry'

module RackMetrics
  class Middleware
    def initialize(app, registry:, path: '/metrics')
      @app = app
      @registry = registry
      @path = path
    end

    def call(env)
      # Якщо запит іде на наш шлях /metrics, повертаємо зібрані дані
      if env['PATH_INFO'] == @path
        return [200, { 'Content-Type' => 'text/plain' }, [@registry.to_s]]
      end

      # 1. Засікаємо час початку
      start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      
      # 2. Викликаємо додаток
      status, headers, body = @app.call(env)
      
      # 3. Засікаємо час кінця
      end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      
      # 4. Розраховуємо латентність у мілісекундах
      duration_ms = (end_time - start_time) * 1000

      # 5. Розраховуємо розмір відповіді
      response_size = 0
      if headers['Content-Length']
        response_size = headers['Content-Length'].to_i
      elsif body.respond_to?(:each)
        # Якщо Content-Length не вказано, рахуємо вручну
        body.each { |chunk| response_size += chunk.bytesize }
      end

      # 6. Записуємо метрики
      @registry.record_request(status, duration_ms, response_size)

      # 7. Повертаємо оригінальну відповідь
      [status, headers, body]
    end
  end
end