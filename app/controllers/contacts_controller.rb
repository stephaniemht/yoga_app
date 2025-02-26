class ContactsController < ApplicationController
  def new
    @contact = OpenStruct.new
  end

  def create
    contact_params = params.require(:contact).permit(:first_name, :last_name, :email, :message)

    if contact_params.values.all?(&:present?) # Vérifie que tous les champs sont remplis
      ContactMailer.contact_email(contact_params).deliver_now
      flash[:notice] = "Votre message a bien été envoyé."
      redirect_to root_path
    else
      flash[:alert] = "Erreur lors de l'envoi du message. Tous les champs sont requis."
      render :new, status: :unprocessable_entity
    end
  end
end
