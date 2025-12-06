class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # 👀 Pour les visiteurs : on cache les cours suspendus
    # 👩‍💻 Pour l'admin : on voit tout, y compris les suspendus
    if user_signed_in? && current_user.admin?
      @courses = Course.order(start_time: :asc, title: :asc)
    else
      @courses = Course
        .where(suspended: [false, nil])
        .order(start_time: :asc, title: :asc)
    end
  end

  def show
    @course = Course.find(params[:id])

    # Si le cours est suspendu, seul l'admin peut le voir
    if @course.suspended? && !(user_signed_in? && current_user.admin?)
      redirect_to courses_path, alert: "Ce cours n'est pas disponible pour le moment."
    end
  end

  def new
    @course = Course.new
    # valeurs par défaut
    @course.recurring = false
    @course.suspended = false
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user if defined?(current_user) && current_user.present?

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
    params.require(:course).permit(
      :title,
      :description,
      :location,
      :duration,
      :price,
      :photo,
      :start_time,
      :recurring,
      :day_1,
      :time_1,
      :day_2,
      :time_2,
      :suspended
    )
  end
end
