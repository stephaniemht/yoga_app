class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  def index
    # 👀 Visiteurs : on cache les cours suspendus
    # 👩‍💻 Admin : voit tout, y compris suspendus
    scope = if user_signed_in? && current_user.admin?
              Course.all
            else
              Course.where(suspended: [false, nil])
            end

    @courses = scope.order(start_time: :asc, title: :asc)
  end

  def show
    # Si le cours est suspendu, seul l'admin peut le voir
    if @course.suspended? && !(user_signed_in? && current_user.admin?)
      redirect_to courses_path, alert: "Ce cours n'est pas disponible pour le moment."
    end
  end

  def new
    @course = Course.new(
      recurring: false,
      suspended: false
    )

    # On prépare quelques lignes vides de créneaux pour le formulaire
    3.times { @course.course_schedules.build }
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user if defined?(current_user) && current_user.present?

    if @course.save
      redirect_to @course, notice: "Événement créé avec succès."
    else
      # Si ça plante, on remet des créneaux vides pour ne pas avoir un form « vide »
      (3 - @course.course_schedules.size).times { @course.course_schedules.build }
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # On s'assure d'avoir au moins quelques lignes de créneaux affichées
    (3 - @course.course_schedules.size).times { @course.course_schedules.build }
  end

  def update
    if @course.update(course_params)
      redirect_to @course, notice: "Le cours a bien été mis à jour."
    else
      (3 - @course.course_schedules.size).times { @course.course_schedules.build }
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_path, notice: "Le cours a bien été supprimé."
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

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
      :suspended,
      course_schedules_attributes: [:id, :weekday, :time, :_destroy]
    )
  end
end
