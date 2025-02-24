class AdminController < ApplicationController
  before_action :authenticate_user! # Seuls les utilisateurs connectés peuvent voir la page
  before_action :only_admin # Seule Jennifer peut y accéder

  def dashboard
    @courses = Course.all
    @hikes = Hike.all
  end

  private

  def only_admin
    redirect_to root_path, alert: "Accès non autorisé" unless current_user.admin?
  end
end
