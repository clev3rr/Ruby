# # # def make_it_speak(speaker)
# # #   # Ми не питаємо "Хто ти?" (якого ти класу?)
# # #   # Ми кажемо "Говори!" (викликаємо .speak)
# # #   speaker.speak
# # # end

# # # class Dog
# # #   def speak
# # #     puts "Гав!"
# # #   end
# # # end

# # # class Politician
# # #   def speak
# # #     puts "Я обіцяю покращення!"
# # #   end
# # # end

# # # # Об'єкти з абсолютно різних, непов'язаних класів
# # # dog = Dog.new
# # # politician = Politician.new

# # # make_it_speak(dog)        #=> Гав!
# # # make_it_speak(politician) #=> Я обіцяю покращення!


# # 1.2
# # # Це наш "абстрактний" клас-контракт
# # class PaymentStrategy
# #   def pay(amount)
# #     # Цей метод ВИМАГАЄ реалізації в нащадках
# #     raise NotImplementedError, "#{self.class} не реалізував метод '.pay'"
# #   end
# # end

# # # Цей клас ПІДПИСУЄ контракт і виконує його
# # class CreditCardPayment < PaymentStrategy
# #   def pay(amount)
# #     puts "Оплачено #{amount} грн кредитною карткою."
# #   end
# # end

# # # Цей клас ПІДПИСУЄ контракт, але "забуває" його виконати
# # class CashPayment < PaymentStrategy
# #   # Немає реалізації .pay
# # end

# # # --- Використання ---
# # card = CreditCardPayment.new
# # cash = CashPayment.new

# # card.pay(100) #=> Оплачено 100 грн кредитною карткою.

# # # cash.pay(50)
# # #=> ПОМИЛКА під час виконання:
# # #   NotImplementedError: CashPayment не реалізував метод '.pay'

# # # 2
# # # 3. Метод модуля (utility-функція)
# # module Formatter
# #   def self.timestamp(message)
# #     "[#{Time.now.strftime('%H:%M:%S')}] #{message}"
# #   end
# # end

# # class Car
# #   @@total_cars_built = 0 # Змінна класу

# #   def initialize(model)
# #     @model = model # Змінна екземпляра
# #     @@total_cars_built += 1
# #   end

# #   # 1. Метод екземпляра
# #   #    Належить об'єкту (my_car), має доступ до @model
# #   def drive
# #     # Використовуємо метод модуля як хелпер
# #     puts Formatter.timestamp("Автомобіль #{@model} їде.")
# #   end

# #   # 2. Метод класу
# #   #    Належить класу Car, має доступ до @@total_cars_built
# #   def self.total_count
# #     puts "Всього збудовано: #{@@total_cars_built} авто."
# #   end
# # end

# # # --- Використання ---

# # # 1. Виклик методу екземпляра (на об'єкті)
# # my_car = Car.new("Tesla")
# # my_car.drive #=> [12:32:38] Автомобіль Tesla їде.

# # another_car = Car.new("Ford")
# # another_car.drive #=> [12:32:38] Автомобіль Ford їде.

# # # 2. Виклик методу класу (на класі)
# # Car.total_count #=> Всього збудовано: 2 авто.

# # # 3. Виклик методу модуля (на модулі)
# # puts Formatter.timestamp("Програма завершується.")
# # #=> [12:32:38] Програма завершується.

# # 3.1 
# # # Батьківський клас з базовою поведінкою
# # class Bird
# #   def fly
# #     puts "Я лечу!"
# #   end
# # end

# # # Горобець успадковує поведінку
# # class Sparrow < Bird
# #   # ... все добре
# # end

# # # Пінгвін теж успадковує поведінку...
# # class Penguin < Bird
# #   def swim
# #     puts "Я плаваю!"
# #   end
# # end

# # # --- Проблема ---
# # sparrow = Sparrow.new
# # sparrow.fly #=> "Я лечу!" (Правильно)

# # penguin = Penguin.new
# # penguin.fly #=> "Я лечу!" (НЕПРАВИЛЬНО! Пінгвіни не літають)

# # 3.2 
# # # Ми виносимо поведінку в окремі модулі (компоненти)
# # module Flyable
# #   def fly
# #     puts "Я лечу!"
# #   end
# # end

# # module Swimmable
# #   def swim
# #     puts "Я плаваю!"
# #   end
# # end

# # # Базовий клас тепер не містить суперечливої поведінки
# # class Bird
# #   # ... (якась загальна логіка, наприклад, def eat)
# # end

# # # Горобець КОМПОНУЄ в собі поведінку Flyable
# # class Sparrow < Bird
# #   include Flyable
# # end

# # # Пінгвін КОМПОНУЄ в собі поведінку Swimmable
# # class Penguin < Bird
# #   include Swimmable
# # end

# # # --- Рішення ---
# # sparrow = Sparrow.new
# # sparrow.fly #=> "Я лечу!" (Правильно)

# # penguin = Penguin.new
# # penguin.swim #=> "Я плаваю!" (Правильно)
# # # penguin.fly #=> NoMethodError (Правильно! Він і не повинен)

# # 4
# # # Власний клас помилки
# # class InsufficientFundsError < StandardError
# #   attr_reader :shortage
# #   def initialize(message, shortage = 0)
# #     super(message)
# #     @shortage = shortage
# #   end
# # end

# # def process_payment(balance, amount)
# #   # Початок "небезпечної" зони
# #   begin
# #     puts "1. Починаємо транзакцію..."

# #     # Кидаємо стандартну помилку
# #     if amount <= 0
# #       raise ArgumentError, "Сума має бути позитивною."
# #     end

# #     # Кидаємо власну помилку
# #     if amount > balance
# #       shortage = amount - balance
# #       raise InsufficientFundsError.new("Недостатньо коштів.", shortage)
# #     end

# #     puts "2. Успішно списано #{amount} грн."
    
# #   # Рятуємо власну помилку
# #   rescue InsufficientFundsError => e
# #     puts "ПОМИЛКА ПЛАТЕЖУ: #{e.message} (Не вистачає: #{e.shortage} грн)"
    
# #   # Рятуємо загальну помилку (завдяки ієрархії)
# #   rescue StandardError => e
# #     puts "ПОМИЛКА ВАЛІДАЦІЇ: #{e.message}"

# #   # Цей блок виконається завжди
# #   ensure
# #     puts "3. Завершення транзакції (очистка)."
# #   end
# # end

# # # --- Тестуємо ---
# # puts "--- Сценарій 1: Успіх ---"
# # process_payment(100, 50)

# # puts "\n--- Сценарій 2: Власна помилка ---"
# # process_payment(100, 150)

# # puts "\n--- Сценарій 3: Загальна помилка ---"
# # process_payment(100, -10)

# # 5
# module Log
#   def log(message)
#     puts "LOG: #{message}"
#   end
# end

# # --- 1. include (Метод екземпляра) ---
# class TaskInclude
#   include Log # Методи Log тепер доступні на екземплярах

#   def run
#     # Ми викликаємо .log як звичайний метод екземпляра
#     log("Завдання виконується...")
#   end
# end

# task_i = TaskInclude.new
# task_i.run #=> "LOG: Завдання виконується..."


# # --- 2. extend (Метод класу) ---
# class TaskExtend
#   extend Log # Методи Log тепер доступні на класі

#   def self.show_help
#     # Ми викликаємо .log як метод класу
#     log("Це довідка по класу TaskExtend.")
#   end
# end

# TaskExtend.show_help #=> "LOG: Це довідка по класу TaskExtend."
# # TaskExtend.new.log("...") #=> NoMethodError (на екземплярі методу немає)


# # --- 3. prepend (Перевизначення / Обгортка) ---
# module DetailedLog
#   def run
#     puts "LOG (prepend): Завдання ось-ось почнеться..."
#     super # Викликаємо оригінальний метод .run з класу
#     puts "LOG (prepend): Завдання завершило роботу."
#   end
# end

# class TaskPrepend
#   prepend DetailedLog # Модуль "головніший" за клас

#   def run
#     puts "   ...виконання основного завдання..."
#   end
# end

# task_p = TaskPrepend.new
# task_p.run
# #=> LOG (prepend): Завдання ось-ось почнеться...
# #=>    ...виконання основного завдання...
# #=> LOG (prepend): Завдання завершило роботу.