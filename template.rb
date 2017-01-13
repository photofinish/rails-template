

gem_group :development do
  #gem 'redis-stat'
  #gem 'spork', git: 'https://github.com/sporkrb/spork', branch: 'master'
  #gem 'guard-spork'
  #gem 'spork-rails'

  # devel tool
  gem 'awesome_print'
  gem 'better_errors'
  gem 'binding_of_caller'

  # rspec
  gem 'rspec-rails'
  gem 'libnotify'
  gem 'rb-inotify'

  # capybara
  gem 'capybara'
  gem 'selenium-webdriver'
  #gem 'capybara-webkit'
  gem 'database_cleaner'

  # guard
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-migrate'
  gem 'guard-annotate'
  gem 'guard-shell'
  gem 'guard-livereload'

  # profiler
  gem 'rack-mini-profiler'
  gem 'memory_profiler'
  gem 'flamegraph'
  gem 'stackprof'

  # redis
  gem 'redis'
  gem 'redis-rails'
  gem 'redis-rack-cache'

end

# application.rb
generators_config = <<-CODE

    config.generators do |g|
      g.assets = false
      g.helper = false
      g.test_framework = false
    end

    config.cache_store = :redis_store, "redis://127.0.0.1:6379/0/cache", { expires_in: 90.minutes }

    config.action_dispatch.rack_cache = {
      metastore: "redis://localhost:6379/0/metastore",
      entitystore: "redis://localhost:6379/0/entitystore"
    }

CODE

gsub_file 'Gemfile', 'source \'https://rubygems.org\'', 'source \'https://gems.ruby-china.org\''

environment generators_config

comment_lines 'config/initializers/session_store.rb', /cookie_store/

append_to_file 'config/initializers/session_store.rb' do
  'Rails.application.config.session_store :redis_store, servers: "redis://localhost:6379/0/session"'
end

initializer('redis.rb') do
<<-CODE
$redis = Redis.new(:host => '127.0.0.1', :port => 6379, :db => 0)
CODE
end





after_bundle do
  inside('.') do
    run "bundle exec guard init"
  end
end
