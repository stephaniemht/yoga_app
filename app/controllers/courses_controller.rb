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
