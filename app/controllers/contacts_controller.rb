class ContactsController < ApplicationController
  def create
    contact_params = params.permit(:first_name, :last_name, :email, :phone, :message)

    if contact_params.values.all?(&:present?)
      ContactMailer.contact_email(contact_params).deliver_now
      flash[:notice] = "Votre message a bien été envoyé."
      redirect_to root_path
    else
      flash[:alert] = "Erreur lors de l'envoi du message. Tous les champs sont requis."
      redirect_to root_path, status: :unprocessable_entity
    end
  end
end
