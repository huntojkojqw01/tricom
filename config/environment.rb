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
  # delivery_method :smtp, {
  #     :address => 'mail.jpt.co.jp',
  #     :port => '465',
  #     #:domain => 'heroku.com',
  #     :user_name => 'skybord@jpt.co.jp',
  #     :password => 'LD-RJ45T10A',
  #     :authentication => :login,
  #     :enable_starttls_auto => true
  # }
  delivery_method :smtp, {
      :address => 'smtp.gmail.com',
      :port => '587',
      #:domain => 'heroku.com',
      :user_name => 'skyfordtricom@gmail.com',
      :password => 'cmcjpt1Z',
      # :authentication => :login,
      :authentication => :plain,
      :enable_starttls_auto => true
  }
end
