source "https://rubygems.org"

gem "rails", "~> 8.1.3", ">= 8.1.3.1"
gem "propshaft" # The modern asset pipeline
gem "pg", "~> 1.6" # Use postgresql as the database for AR
gem "puma", ">= 5.0" # Use the Puma web server
gem "jsbundling-rails" # Bundle and transpile JavaScript
gem "cssbundling-rails" # Bundle and process CSS
gem "turbo-rails" # Hotwire's SPA-like page accelerator
gem "stimulus-rails" # Hotwire's modest JavaScript framework
# gem "jbuilder" # Build JSON APIs with ease

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "bootsnap", require: false # Reduces boot times through caching; required in config/boot.rb
gem "kamal", require: false # Deploy this application anywhere as a Docker container
gem "thruster", require: false # Add HTTP asset caching/compression and X-Sendfile acceleration to Puma

gem "ruby-vips", "~> 2.3" # libvips backend for Active Storage variants
gem "image_processing", "~> 2.0" # Use Active Storage variants

# gem "devise" # Authentication (users, attorneys, defendants)
# gem "devise_invitable" # Invite users (attorney invites defendant)
# gem "pundit" # Authorization (roles, permissions, access control)
# gem "pg_search" # Full-text search using PostgreSQL
# gem "premailer-rails", "~> 1.12" # Inline email CSS before delivery.
# gem "validate_url" # Validate URLs
# gem "pagy", "~> 43.5" # Pagination / infinite scrolling
# gem "ransack", "~> 4.4" # Search
# gem "validates_timeliness" # Validate dates and date ranges
# gem "paper_trail" # Track changes (who edited what and when)
# gem "auto_strip_attributes", "~> 2.6" # Remove unnecessary whitespaces from ActiveRecord or ActiveModel attributes
# gem "page_title_helper", "~> 10.0" # Internationalized page titles and headings

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "bundler-audit", require: false # Audits gems for known security defects (use config/bundler-audit.yml to ignore issues)
  gem "brakeman", require: false # Static analysis for security vulnerabilities
  gem "rubocop-rails-omakase", require: false # # Omakase Ruby styling

  gem "faker" # Generate fake data

  gem "erb_lint", require: false # Lint ERB templates
end

group :development do
  gem "erbfmt", "0.3.0", require: false # Format HTML+ERB templates
  gem "web-console" # Use console on exceptions pages
  gem "chrome_devtools_rails" # Expose Chrome DevTools workspace mapping metadata in development.
  gem "letter_opener" # Preview email in the browser instead of sending it
  gem "rails-erd" # Entity-Relationship Diagrams for Rails applications
  gem "ruby-graphviz" # Graphviz output support for rails-erd PNG/PDF/SVG diagrams
  gem "chusaku", require: false # Controller annotations
  gem "annotaterb" # Annotate models, routes, fixtures, etc.

  # gem "bullet" # Detect N+1 queries
  # gem "rack-mini-profiler" # Performance profiling
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  # gem "rspec-rails" # Testing framework
  # gem "factory_bot_rails" # Test data factories
  # gem "simplecov", require: false # Test coverage
end
