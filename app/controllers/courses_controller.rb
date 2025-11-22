class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # On n'affiche pas les cours suspendus
    @courses = Course.where(suspended: false).order(:title)
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
    # Par défaut : cours non récurrent, date libre si besoin
    @course.start_time = nil
    @course.recurring = false
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
    # On garde :start_time pour les cours ponctuels
    # + nouveaux champs pour les cours récurrents
    params.require(:course).permit(
      :title,
      :description,
      :start_time,
      :location,
      :duration,
      :price,
      :photo,
      :recurring,   # boolean
      :day_1,       # integer (0 = dimanche, 1 = lundi, etc.)
      :time_1,      # type :time
      :day_2,       # optionnel
      :time_2,      # optionnel
      :suspended    # boolean pour suspendre le cours
    )
  end
end
