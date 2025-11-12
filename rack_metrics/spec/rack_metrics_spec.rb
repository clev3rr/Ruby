# spec/rack_metrics_spec.rb
# frozen_string_literal: true

require 'rack/test'
require 'rack_metrics/registry'
require 'rack_metrics/middleware'

RSpec.describe RackMetrics::Middleware do
  include Rack::Test::Methods

  # 1. Створюємо "піддослідний" додаток
  # ---- ВИПРАВЛЕНО ТУТ ----
  let(:test_app) do
    # Це простий Rack-додаток (lambda)
    lambda { |_env| [200, { 'Content-Length' => '5' }, ['Hello']] }
  end

  # 2. Створюємо "повільний" додаток
  let(:slow_app) do
    lambda { |_env| sleep 0.06; [200, { 'Content-Length' => '4' }, ['Slow']] }
  end

  # 3. Створюємо наш реєстр
  let(:registry) { RackMetrics::Registry.new }
  
  # 4. Створюємо наше middleware
  # ---- ТА ВИПРАВЛЕНО ТУТ ----
  let(:middleware) { RackMetrics::Middleware.new(test_app, registry: registry) }
  let(:slow_middleware) { RackMetrics::Middleware.new(slow_app, registry: registry) }

  # 5. `app` - це спеціальний метод для `rack-test`. 
  # Тепер він не конфліктує з `let(:test_app)`
  def app
    middleware
  end

  it "повертає правильний статус та тіло (просто перевірка)" do
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('Hello')
  end

  it "рахує загальну кількість запитів" do
    get '/'
    get '/foo'
    expect(registry.to_s).to include("requests_total: 2")
  end

  it "рахує статуси 2xx" do
    get '/'
    expect(registry.to_s).to include("status_codes_2xx: 1")
    expect(registry.to_s).to include("status_codes_5xx: 0")
  end

  it "записує латентність у правильний кошик" do
    # Тут ми локально перевизначаємо `app`, що є нормальним
    def app
      slow_middleware
    end
    
    get '/' # 60ms
    
    expect(registry.to_s).to include("latency_le_100: 1")
    expect(registry.to_s).to include("latency_le_50: 0")
  end

  it "записує розмір у правильний кошик" do
    get '/' # 'Hello' (5 байт)
    expect(registry.to_s).to include("size_le_100: 1")
  end

  it "показує метрики на шляху /metrics" do
    get '/metrics'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("requests_total: 0")
  end
end