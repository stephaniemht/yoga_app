class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # On cache les cours suspendus, et on trie par date de prochaine séance connue
    @courses = Course
      .where(suspended: [false, nil])
      .order(start_time: :asc)
  end

  def show
    @course = Course.find(params[:id])
  end

  def new
    @course = Course.new
    # valeurs par défaut
    @course.recurring = false
    @course.suspended = false
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user if defined?(current_user)

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
    # on ajoute ici tous les nouveaux champs
    params.require(:course).permit(
      :title,
      :description,
      :start_time,
      :location,
      :duration,
      :price,
      :photo,
      :recurring,   # booléen : cours régulier ?
      :day_1,       # premier jour récurrent (integer)
      :time_1,      # horaire du premier jour (time)
      :day_2,       # deuxième jour récurrent (integer, optionnel)
      :time_2,      # horaire du deuxième jour (time, optionnel)
      :suspended    # booléen : cours suspendu ?
    )
  end
end
