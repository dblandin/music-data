@dir = '/var/www/music-data'

worker_processes 2
working_directory "#{@dir}/current"

timeout 30

listen "#{@dir}/shared/tmp/sockets/unicorn.sock", backlog: 64

# Set process id path
pid "#{@dir}/shared/tmp/pids/unicorn.pid"

# Set log file paths
stderr_path "#{@dir}/current/log/unicorn.stderr.log"
stdout_path "#{@dir}/current/log/unicorn.stdout.log"

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)

  Sidekiq.configure_client do |config|
    config.redis = {
      url:       ENV['REDIS_URL'],
      namespace: 'sidekiq',
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
