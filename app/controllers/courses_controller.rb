class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # On suppose que tu veux trier par start_time au lieu de :date
    @courses = Course.order(start_time: :asc)
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    # Nouvel objet, on initialise start_time à l'heure actuelle
    @course = Course.new
    @course.start_time = Time.zone.now
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user  # si tu lies chaque cours à un user

    if @course.save
      redirect_to @course, notice: "Événement créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @course = Course.find(params[:id])
  end

  def update
    @course = Course.find(params[:id])
    if @course.update(course_params)
      redirect_to @course, notice: "Le cours a bien été mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy
    redirect_to courses_path, notice: "Le cours a bien été supprimé."
  end

  private

  def course_params
    # IMPORTANT : on utilise :start_time, pas :time, ni :date
    params.require(:course).permit(:title, :description, :start_time, :location, :duration, :price, :photo)
  end
end
