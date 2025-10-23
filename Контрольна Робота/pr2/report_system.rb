# report_system.rb

# --- 1. Клас "Контекст" (Context) ---
# Він не знає, ЯК форматувати, але знає, КОГО попросити.
class Report
  attr_accessor :title, :body
  attr_accessor :formatter # Тут зберігається об'єкт-стратегія

  def initialize(title, body, formatter)
    @title = title
    @body = body
    @formatter = formatter
  end

  # Метод, що делегує роботу стратегії
  def output
    # Ми просто викликаємо метод нашої стратегії,
    # передаючи себе (або потрібні дані).
    @formatter.format_report(@title, @body)
  end
end

# --- 2. "Інтерфейс" Стратегії ---
# Ми просто домовляємось, що всі стратегії матимуть метод .format_report

# --- 3. Конкретні Стратегії ---

# Стратегія 1: Текстове форматування
class TextFormatter
  def format_report(title, body)
    puts "--- Стратегія: Text ---"
    output = "*** #{title} ***\n\n"
    output += body
    output += "\n\n*** Кінець звіту ***"
    output
  end
end

# Стратегія 2: Markdown форматування
class MarkdownFormatter
  def format_report(title, body)
    puts "--- Стратегія: Markdown ---"
    output = "# #{title}\n\n"
    output += body
    output
  end
end

# Стратегія 3: HTML форматування
class HtmlFormatter
  def format_report(title, body)
    puts "--- Стратегія: HTML ---"
    output = "<html>\n  <head>\n    <title>#{title}</title>\n  </head>\n"
    output += "  <body>\n    <h1>#{title}</h1>\n    <p>#{body}</p>\n  </body>\n</html>"
    output
  end
end

# --- 4. Використання ---

# Створюємо "сирі" дані для звіту
TITLE = "Місячний звіт"
BODY = "Продажі йдуть добре."

# 1. Створюємо звіт, передаючи йому СТРАТЕГІЮ TextFormatter
report = Report.new(TITLE, BODY, TextFormatter.new)
puts report.output

puts "\n" + "="*30 + "\n"

# 2. Тепер передаємо тому ж звіту іншу СТРАТЕГІЮ
report.formatter = HtmlFormatter.new
puts report.output

puts "\n" + "="*30 + "\n"

# 3. І третю
report.formatter = MarkdownFormatter.new
puts report.output