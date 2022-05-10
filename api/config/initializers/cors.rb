Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'https://pf-advancey.com', 'http://localhost:8080', 'http://localhost:8081'
    # origins ['https://pf-advancey.com', 'http://localhost:8080', 'http://localhost:8081']

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head]
  end
end
