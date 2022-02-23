server '54.65.215.44', user: 'yusuke', roles: %w[app db web]

set :ssh_options, {
  keys: %w[~/.ssh/pf-keypair.pem],
  forward_agent: true,
  auth_methods: %w[publickey]
}
# a
