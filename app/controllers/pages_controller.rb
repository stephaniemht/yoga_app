class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @next_course = Course.where("date >= ?", Date.today).order(:date).first
    @next_hike = Hike.where("date >= ?", Date.today).order(:date).first
  end
end
