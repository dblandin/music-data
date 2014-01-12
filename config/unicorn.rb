preload_app       true
pid               ENV['UNICORN_PIDFILE']
worker_processes  (ENV['UNICORN_WORKERS'] || 8).to_i
timeout           (ENV['UNICORN_TIMEOUT'] || 60).to_i
listen            ENV['UNICORN_LISTEN'], backlog: (ENV['UNICORN_BACKLOG'] || 8).to_i

# Buffer up to 2mb before caching to disk
client_body_buffer_size 2097152

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord::Base)

  # Gracefully kill the previous Unicorn binary
  old_pidfile = "#{ENV['UNICORN_PIDFILE']}.oldbin"

  if File.exists?(old_pidfile) && server.pid != old_pidfile
    begin
      Process.kill('QUIT', File.read(old_pidfile).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

