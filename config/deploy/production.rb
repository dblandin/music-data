set :stage, :production
set :dotenv, 'config/production.env'

server '192.241.143.82', user: 'deploy', roles: %w[web app db clock]
