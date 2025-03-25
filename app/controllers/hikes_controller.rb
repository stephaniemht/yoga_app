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


  private

  def hike_params
    params.require(:hike).permit(:title, :location, :description, :date, :time, :end_date, :price, :photo)
  end
end
