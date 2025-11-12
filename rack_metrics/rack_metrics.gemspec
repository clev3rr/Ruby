# frozen_string_literal: true

require_relative "lib/rack_metrics/version"

Gem::Specification.new do |spec|
  spec.name = "rack_metrics"
  spec.version = RackMetrics::VERSION
  spec.authors = ["Maksym Maliutin"]
  spec.email = ["maksym.maliutin@student.karazin.ua"]

  spec.summary = "Rack middleware for collecting request metrics."
  spec.description = "Collects request counts, latency histograms, and response size histograms."
  spec.homepage = "https://github.com/clev3rr/Ruby" # URL вашого репо
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # Коментуємо, оскільки поки не публікуємо гем
  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  # Припускаючи, що ваш гем живе у підпапці rack_metrics:
  spec.metadata["source_code_uri"] = "https://github.com/clev3rr/Ruby/tree/main/rack_metrics"
  spec.metadata["changelog_uri"] = "https://github.com/clev3rr/Ruby/blob/main/rack_metrics/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # --- НАШІ ЗАЛЕЖНОСТІ ---

  # Головна залежність для роботи
  spec.add_dependency "rack"

  # Залежності для розробки (тести, демо)
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "puma"
  
  # RSpec та RuboCop вже мають бути додані Bundler'оm
  # spec.add_development_dependency "rspec"
  # spec.add_development_dependency "rubocop"
  # --------------------------
end