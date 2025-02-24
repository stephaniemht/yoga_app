class ContactMailer < ApplicationMailer
  default to: 'stephanie.mihut@gmail.com' # Remplace par l'email où tu veux recevoir les messages

  def contact_email(contact_params)
    @contact = contact_params
    mail(
      from: @contact[:email],
      subject: "Nouveau message de #{@contact[:first_name]} #{@contact[:last_name]}"
    )
  end
end
