role :app, %w{deploy@128.199.173.133}
role :web, %w{deploy@128.199.173.133}
role :db, %w{deploy@128.199.173.133}

set :application, 'production'
set :branch, 'master'
set :deploy_to, "/var/www/fshop/#{fetch(:application)}"

server '128.199.173.133',
       user: 'deploy',
       roles: %w{web app},
       ssh_options: {
         user: 'deploy', # overrides user setting above
         #keys: %w(/home/deployer/.ssh/id_rsa),
         forward_agent: true,
         auth_methods: %w(publickey password)
         # password: 'please use keys'
       }