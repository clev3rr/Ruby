# Інтерфейс віддаленого сервісу
class ThirdPartyYouTubeLib
  def list_videos
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def get_video_info(id)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def download_video(id)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Конкретна реалізація сервісу
class ThirdPartyYouTubeClass < ThirdPartyYouTubeLib
  def list_videos
    puts "Запитуємо список відео з YouTube..."
    ["video1", "video2", "video3"]
  end

  def get_video_info(id)
    puts "Отримуємо інформацію про відео #{id} з YouTube..."
    { id: id, title: "Відео #{id}", duration: "5:00" }
  end

  def download_video(id)
    puts "Завантажуємо відео #{id} з YouTube..."
  end
end

# Кешуючий замісник
class CachedYouTubeClass < ThirdPartyYouTubeLib
  def initialize(service)
    @service = service
    @list_cache = nil
    @video_cache = {}
    @need_reset = false
  end

  def list_videos
    if @list_cache.nil? || @need_reset
      puts "Кеш відсутній або застарів. Отримуємо новий список відео..."
      @list_cache = @service.list_videos
    else
      puts "Беремо список відео з кешу."
    end
    @list_cache
  end

  def get_video_info(id)
    if @video_cache[id].nil? || @need_reset
      puts "Кеш для відео #{id} відсутній або застарів. Отримуємо нові дані..."
      @video_cache[id] = @service.get_video_info(id)
    else
      puts "Беремо інформацію про відео #{id} з кешу."
    end
    @video_cache[id]
  end

  def download_video(id)
    puts "Перевіряємо, чи відео #{id} вже завантажено..."
    unless download_exists?(id) && !@need_reset
      @service.download_video(id)
    else
      puts "Відео #{id} вже завантажене."
    end
  end

  private

  def download_exists?(id)
    # Емуляція перевірки локального файлу
    false
  end
end

# Клас клієнта (GUI)
class YouTubeManager
  def initialize(service)
    @service = service
  end

  def render_video_page(id)
    info = @service.get_video_info(id)
    puts "Відображаємо сторінку відео: #{info[:title]} (#{info[:duration]})"
  end

  def render_list_panel
    list = @service.list_videos
    puts "Відображаємо список відео:"
    list.each { |video| puts " - #{video}" }
  end

  def react_on_user_input
    render_list_panel
    render_video_page("video1")
  end
end

# Конфігураційна частина
class Application
  def init
    you_tube_service = ThirdPartyYouTubeClass.new
    you_tube_proxy = CachedYouTubeClass.new(you_tube_service)
    manager = YouTubeManager.new(you_tube_proxy)
    manager.react_on_user_input

    puts "\n--- Повторний виклик (використає кеш) ---"
    manager.react_on_user_input
  end
end

# Запуск програми
app = Application.new
app.init
