# Load the Rails application.[Setting this value for oracle support japanese in sql query]
ENV['NLS_LANG'] = 'japanese_japan.al32utf8'
# production mode
ENV['RAILS_ENV'] ||= 'production'

require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Jpt::Application.initialize!

require 'composite_primary_keys'

require 'mail'

Mail.defaults do
  delivery_method :smtp, {
      :address => 'smtp.sendgrid.net',
      :port => '587',
      :domain => 'heroku.com',
      :user_name => ENV['SENDGRID_USERNAME'],
      :password => ENV['SENDGRID_PASSWORD'],
      :authentication => :plain,
      :enable_starttls_auto => true
  }
end