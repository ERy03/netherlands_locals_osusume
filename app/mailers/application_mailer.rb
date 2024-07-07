class ApplicationMailer < ActionMailer::Base
  default from: "Netherlands Locals Osusume <#{ENV['DEFAULT_EMAIL']}>"
  layout "mailer"
end
