class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @courses = Course.order(date: :asc)
  end

  def show
    @course = Course.find(params[:id])

  end

  def new
    @course = Course.new
    @course.start_time = Time.zone.now
  end

  def start_time
    raw = super
    # Si raw est nil, retourne nil
    return nil if raw.nil?
    # Si raw est déjà un objet Time, ActiveSupport::TimeWithZone ou DateTime, on le retourne directement
    return raw if raw.is_a?(ActiveSupport::TimeWithZone) || raw.is_a?(DateTime) || raw.is_a?(Time)
    # Sinon, on essaie de le convertir en temps
    Time.zone.parse(raw.to_s) rescue nil
  end

  def create
    @course = Course.new(course_params)
    @course.user = current_user

    if @course.save
      redirect_to course_path(@course), notice: "Événement créé avec succès."
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
      redirect_to course_path(@course), notice: "Le cours a bien été mis à jour."
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
    params.require(:course).permit(:title, :description, :date, :location, :duration, :price, :photo, :time)
  end
end
