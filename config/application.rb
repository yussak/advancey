require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PortfolioApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # rails デフォルトを日本語にする
    config.i18n.default_locale = :ja

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.time_zone = 'Tokyo'
    # config.eager_load_paths << Rails.root.join("extras")

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      if File.exist?(env_file)
        YAML.load(File.open(env_file)).each do |key, value|
          ENV[key.to_s] = value
        end
      end
    end

    # JSが無効になっていた時のための設定。認証トークンをremoteフォームに埋め込む
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
