require 'rack_metrics/registry'

module RackMetrics
  class Middleware
    def initialize(app, registry:, path: '/metrics')
      @app = app
      @registry = registry
      @path = path
    end

    def call(env)
      if env['PATH_INFO'] == @path
        return [200, { 'Content-Type' => 'text/plain' }, [@registry.to_s]]
      end

      start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      
      status, headers, body = @app.call(env)

      end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      
      duration_ms = (end_time - start_time) * 1000

      response_size = 0
      if headers['Content-Length']
        response_size = headers['Content-Length'].to_i
      elsif body.respond_to?(:each)
        body.each { |chunk| response_size += chunk.bytesize }
      end

      @registry.record_request(status, duration_ms, response_size)

      [status, headers, body]
    end
  end
end