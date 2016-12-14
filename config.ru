# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application


# require 'sinatra/base'
# 
# class MyApp < Sinatra::Base
#   get '/' do
#     "Hello, Phusion Passenger #{PhusionPassenger::VERSION_STRING}!"
#   end
# end
# 
# run MyApp