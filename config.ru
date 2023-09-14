# config.ru

require_relative './server'
require 'puma'

run Sinatra::Application
