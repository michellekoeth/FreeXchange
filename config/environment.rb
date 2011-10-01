# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
FreeXChange::Application.initialize!

config.action_mailer.deconfig.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'gmail.com'
  :user_name            => 'freexchange1@gmail.com',
  :password             => ENV['googpass'],
  :authentication       => 'plain',
  :enable_starttls_auto => true  }

