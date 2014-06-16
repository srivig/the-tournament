Airbrake.configure do |config|
  config.api_key = '7220fa1c2ae8944631e274a59884674b'
  config.host    = 'errbit-notsobad.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
