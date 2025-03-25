class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @next_course = Course.where("start_time >= ?", Time.zone.now).order(:start_time).first
    @next_hike = Hike.where("date >= ?", Date.today).order(:date).first
  end

end
