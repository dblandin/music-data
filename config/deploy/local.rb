set :stage, :local
set :dotenv, 'config/local.env'

server '127.0.0.1:2222', user: 'deploy', roles: %w[web app db]
