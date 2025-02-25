class ContactsController < ApplicationController
  def new
  end
  
  def create
    @contact = params.require(:contact).permit(:first_name, :last_name, :email, :message)

    if @contact.present?
      ContactMailer.contact_email(@contact).deliver_now
      flash[:notice] = "Votre message a bien été envoyé."
      redirect_to root_path
    else
      flash[:alert] = "Erreur lors de l'envoi du message."
      render :new
    end
  end
end
