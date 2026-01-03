class HikesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @hikes = Hike.order(date: :asc)
  end

  def show
    @hike = Hike.find(params[:id])
  end

  def new
    @hike = Hike.new
  end

  def create
    @hike = Hike.new(hike_params)
    @hike.user = current_user

    if @hike.save
      redirect_to hike_path(@hike), notice: "Événement créé avec succès."
    else
      puts @hike.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @hike = Hike.find(params[:id])
  end

  def update
    @hike = Hike.find(params[:id])
    Rails.logger.info "PARAMS HIKE: #{params[:hike].inspect}"

    if @hike.update(hike_params)
      redirect_to hike_path(@hike), notice: "La randonnée a bien été mise à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hike = Hike.find(params[:id])
    @hike.destroy
    redirect_to hikes_path, notice: "La randonnée a bien été supprimée."
  end

  def destroy_carousel_photo
    @hike = Hike.find(params[:id])

    # sécurité : admin only
    unless user_signed_in? && current_user.admin?
      redirect_to @hike, alert: "Accès non autorisé."
      return
    end

    attachment = @hike.carousel_photos.attachments.find_by(id: params[:attachment_id])

    if attachment
      attachment.purge
      redirect_to edit_hike_path(@hike), notice: "Photo supprimée."
    else
      redirect_to edit_hike_path(@hike), alert: "Photo introuvable."
    end
  end


  private

  def hike_params
    permitted = params.require(:hike).permit(
      :title,
      :location,
      :description,
      :date,
      :time,
      :end_date,
      :price,
      :photo,
      carousel_photos: []
    )

    # ✅ Normalise : peut être [""] ou "" ou nil ou un fichier
    if permitted.key?(:carousel_photos)
      files = Array.wrap(permitted[:carousel_photos]).reject(&:blank?)

      if files.empty?
        permitted.delete(:carousel_photos) # => Rails ne touche pas aux photos existantes
      else
        permitted[:carousel_photos] = files
      end
    end

    permitted
  end
end
