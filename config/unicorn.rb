require 'sidekiq'

preload_app      true
worker_processes (ENV['UNICORN_WORKERS'] || 8).to_i
timeout          (ENV['UNICORN_TIMEOUT'] || 30).to_i
listen           ENV['UNICORN_LISTEN'], backlog: (ENV['UNICORN_BACKLOG'] || 8).to_i
pid              ENV['UNICORN_PIDFILE']

stderr_path ENV['UNICORN_ERROR_LOG']
stderr_path ENV['UNICORN_LOG']

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)

  Sidekiq.configure_client do |config|
    config.redis = {
      url:       ENV['REDIS_URL'],
      namespace: ENV['SIDEKIQ_NAMESPACE'],
      timeout:   1,
      size:      16
    }
  end

  # Gracefully kill the previous Unicorn binary
  old_pidfile = "#{ENV['UNICORN_PIDFILE']}.oldbin"

  if File.exists?(old_pidfile) && server.pid != old_pidfile
    begin
      Process.kill('QUIT', File.read(old_pidfile).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
