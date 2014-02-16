set :stage, :production
set :dotenv, 'config/production.env'

server 'web-1.musicdata.com', user: 'deploy', roles: %w[web app db clock]
server 'web-2.musicdata.com', user: 'deploy', roles: %w[app]
