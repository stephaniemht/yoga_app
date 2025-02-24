class ContactsController < ApplicationController
  def new
  end

  def create
    contact_params = params.permit(:first_name, :last_name, :email, :phone, :message)

    ContactMailer.contact_email(contact_params).deliver_now

    flash[:notice] = "Votre message a bien été envoyé !"
    redirect_to root_path
  end
end

