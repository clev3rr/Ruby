# config.ru
require 'sinatra/base'
require 'rack_metrics' # Підключаємо наш створений гем

# 1. Створюємо "сховище" (Registry).
# Воно має бути одне на весь додаток, щоб дані накопичувалися.
REGISTRY = RackMetrics::Registry.new

# 2. Підключаємо Middleware.
# Ключове слово 'use' каже Rack-серверу: "Використовуй цей прошарок перед тим, як йти до додатку".
# Ми передаємо йому наш registry і кажемо показувати метрики за адресою '/my_custom_metrics'.
use RackMetrics::Middleware, registry: REGISTRY, path: '/my_custom_metrics'

# 3. Це наш тестовий веб-додаток на Sinatra.
class DemoApp < Sinatra::Base
  # Головна сторінка - швидка і проста
  get '/' do
    "Це головна сторінка. \n"
  end

  # Сторінка, яка імітує "гальмування" (затримка 300мс)
  get '/slow' do
    sleep 0.3 
    "Це була повільна сторінка.\n"
  end

  # Сторінка, яка повертає багато даних (20 КБ), щоб перевірити гістограму розміру
  get '/big' do
    response.headers['Content-Type'] = 'text/plain'
    "A" * 20_000
  end

  # Сторінка, яка імітує падіння сервера (помилка 500)
  get '/error' do
    status 500
    "Ой, сталась помилка сервера.\n"
  end
end

# 4. Запускаємо наш додаток
run DemoApp