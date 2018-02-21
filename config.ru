# This file is used by Rack-based servers to start the application.

config.action_dispatch.default_headers = {
    'Access-Control-Allow-Origin' => '*',
    'Access-Control-Request-Method' => %w{GET POST OPTIONS}.join(",")
  }
require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
