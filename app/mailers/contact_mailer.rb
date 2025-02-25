class ContactMailer < ApplicationMailer
  def contact_email(contact_params)
    @contact = contact_params
    mail(
      to: 'stephanie.mihut@gmail.com', # Remplace par ton email réel
      from: ENV['MAILGUN_SMTP_LOGIN'], # Utilise l'adresse validée par Mailgun
      reply_to: @contact[:email], # Permet de répondre à l'expéditeur réel
      subject: "Nouveau message de #{@contact[:first_name]} #{@contact[:last_name]}"
    )
  end
end
