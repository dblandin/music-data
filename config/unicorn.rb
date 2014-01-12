@dir = "/var/www/music-data"

worker_processes 2
working_directory "#{@dir}/current"

timeout 30

listen "#{@dir}/shared/tmp/sockets/unicorn.sock", backlog: 64

# Set process id path
pid "#{@dir}/shared/tmp/pids/unicorn.pid"

# Set log file paths
stderr_path "#{@dir}/current/log/unicorn.stderr.log"
stdout_path "#{@dir}/current/log/unicorn.stdout.log"
