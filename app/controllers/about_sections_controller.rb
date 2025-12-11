class AboutSectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def edit
    @about_section = AboutSection.first_or_create!(
      title: "RANDONNÉE & YOGA POUR SE RECONNECTER À L’ESSENTIEL"
    )
  end

  def update
    @about_section = AboutSection.first_or_create!

    # on attache les nouvelles images si envoyées
    if params[:about_section][:carousel_images].present?
      # 👉 si tu veux remplacer entièrement les anciennes images, décommente la ligne suivante :
      # @about_section.carousel_images.purge

      @about_section.carousel_images.attach(params[:about_section][:carousel_images])
    end

    if @about_section.update(about_section_params)
      redirect_to root_path(anchor: "about"), notice: "La section a bien été mise à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def about_section_params
    # pour l’instant, on laisse title/body optionnels
    params.require(:about_section).permit(:title, :body)
  end

  def require_admin
    redirect_to root_path, alert: "Accès réservé." unless current_user&.admin?
  end
end
