class ContactMailer < ApplicationMailer
  def contact_email(contact_params)
    @contact = contact_params
    mail(
      to: 'stephanie.mihut@gmail.com', # Remplace par ton email
      from: @contact[:email],
      subject: "Nouveau message de #{@contact[:first_name]} #{@contact[:last_name]}"
    )
  end
end
