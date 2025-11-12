# Цей файл використовується Rack-серверами, як-от Puma

# Підключаємо Sinatra та наш гем
require 'sinatra/base'
# require_relative 'lib/rack_metrics' # Для розробки
require 'rack_metrics' # Коли гем встановлено, хоча relative теж спрацює

# --- Налаштування Демо ---

# 1. Створюємо наш реєстр для метрик.
#    Він має бути один на весь додаток.
REGISTRY = RackMetrics::Registry.new

# 2. Підключаємо наше Middleware
#    Важливо: `use` має бути *до* `run`.
#    Ми також змінюємо шлях метрик на /my_custom_metrics
use RackMetrics::Middleware, registry: REGISTRY, path: '/my_custom_metrics'

# 3. Створюємо простий Sinatra-додаток
class DemoApp < Sinatra::Base
  get '/' do
    "Це головна сторінка. \n"
  end

  get '/slow' do
    sleep 0.3 # 300ms
    "Це була повільна сторінка.\n"
  end

  get '/big' do
    # Генеруємо 20KB тіло
    response.headers['Content-Type'] = 'text/plain'
    "A" * 20_000
  end

  get '/error' do
    status 500
    "Ой, сталась помилка сервера.\n"
  end
end

# 4. Запускаємо додаток
run DemoApp