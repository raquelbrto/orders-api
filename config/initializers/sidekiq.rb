require 'sidekiq-unique-jobs'

def configure config
  config.redis = {
    url: ENV["REDIS_HOST"],
    port: ENV["REDIS_PORT"],
    password: ENV["REDIS_PASSWORD"]
  }
end

Sidekiq.configure_client do |config|
  configure(config)

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end

Sidekiq.configure_server do |config|
  configure(config)

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)

  if Rails.env.production?
    config.logger = Rails.logger
  end
end