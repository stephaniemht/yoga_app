class ContactMailer < ApplicationMailer
  def contact_email(contact_params)
    @contact = contact_params

    mail(
      to: 'stephanie.mihut@gmail.com',
      from: 'no-reply@luniversdessens.com', # Modifié pour forcer l'expéditeur
      reply_to: @contact[:email],
      subject: "Nouveau message de #{@contact[:first_name]} #{@contact[:last_name]}"
    )
  end
end

