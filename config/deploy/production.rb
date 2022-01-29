server '54.65.215.44', user: 'yusuke', roles: %w[app db web]

set :ssh_options, {
  keys: %w[~/.ssh/pf-keypair.pem],
  # keys: [ENV.fetch('PRODUCTION_SSH_KEY').to_s],
  forward_agent: true,
  auth_methods: %w[publickey]
}
