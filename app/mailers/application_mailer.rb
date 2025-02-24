class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@luniversdessens.com' # Remplace par un email valide
  layout 'mailer'
end
