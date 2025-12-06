class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # On cache les cours suspendus pour les visiteurs
    scope = Course.where(suspended: [false, nil])

    # Si admin connecté → il voit aussi les suspendus
    if user_signed_in? && current_user.admin?
      scope = Course.all
    end

    @courses = scope.order(start_time: :asc)
  end

  def show
    @course = Course.find(params[:id])

    # Si le cours est suspendu, seuls les admins peuvent le voir
    if @course.suspended? && !(user_signed_in? && current_user.admin?)
      redirect_to courses_path, alert: "Ce cours n'est pas disponible pour le moment."
      return
    end
  end

  def new
    @course = Course.new
    @course.recurring = false
    @course.suspended = false

    # On prépare jusqu'à 7 créneaux possibles
    7.times { @course.course_schedules.build }
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user if defined?(current_user)

    if @course.save
      redirect_to @course, notice: "Événement créé avec succès."
    else
      # si erreurs, on complète pour afficher jusqu'à 7 lignes
      (7 - @course.course_schedules.size).times { @course.course_schedules.build }
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @course = Course.find(params[:id])

    # On complète pour avoir toujours 7 lignes max dans le form
    (7 - @course.course_schedules.size).times { @course.course_schedules.build }
  end

  def update
    @course = Course.find(params[:id])

    if @course.update(course_params)
      redirect_to @course, notice: "Le cours a bien été mis à jour."
    else
      (7 - @course.course_schedules.size).times { @course.course_schedules.build }
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
    params.require(:course).permit(
      :title,
      :description,
      :location,
      :duration,
      :price,
      :photo,
      :start_time,
      :recurring,
      :suspended, # on peut suspendre depuis l’edit
      course_schedules_attributes: [:id, :weekday, :time, :_destroy]
    )
  end
end
