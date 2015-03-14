role :app, %w{deploy@prologic.com.ua}
role :web, %w{deploy@prologic.com.ua}
role :db, %w{deploy@prologic.com.ua}

# set :application, 'staging'
# set :branch, 'develop'

set :rails_env, 'production'
set :application, 'production'
set :branch, 'develop'

#set :deploy_to, "/var/www/fshop/#{fetch(:application)}"

server 'prologic.com.ua',
       user: 'deploy',
       roles: %w{web app},
       ssh_options: {
         user: 'deploy', # overrides user setting above
         #keys: %w(/home/deployer/.ssh/id_rsa),
         forward_agent: true,
         auth_methods: %w(publickey password)
         # password: 'please use keys'
       }