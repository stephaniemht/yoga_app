class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :randonnee ]

  def home
    # 🌿 Cours de yoga ponctuels (non récurrents) à venir : on en prend 2
    @upcoming_courses = Course
      .where(recurring: [false, nil], suspended: [false, nil])
      .where("start_time >= ?", Time.current)
      .order(:start_time)
      .limit(2)

    # 🔁 Cours de yoga réguliers (toujours visibles tant qu'ils ne sont pas suspendus)
    @recurring_courses = Course
      .where(recurring: true, suspended: [false, nil])
      .includes(:course_schedules)

    # 🥾 Prochaine randonnée (tu peux garder ta logique actuelle si elle était différente)
    @next_hike = Hike
      .where("date >= ?", Date.current)
      .order(:date, :time)
      .first

    @presentation = Presentation.first_or_create
    @about_section = AboutSection.first_or_create!(
      title: "RANDONNÉE & YOGA POUR SE RECONNECTER À L’ESSENTIEL"
    )
  end

  def randonnee
  end
end
