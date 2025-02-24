class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @next_courses = Course.where("date >= ?", Time.now).order(date: :asc).limit(3)
    @next_hikes = Hike.where("date >= ?", Time.now).order(date: :asc).limit(3)
  end
end
