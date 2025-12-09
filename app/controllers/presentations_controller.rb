class PresentationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_presentation

  def edit
  end

  def update
    if @presentation.update(presentation_params)
      redirect_to root_path, notice: "La présentation a été mise à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_presentation
    @presentation = Presentation.first_or_create
  end

  def require_admin
    redirect_to root_path unless current_user.admin?
  end

  def presentation_params
    params.require(:presentation).permit(:content, :photo)
  end
end
