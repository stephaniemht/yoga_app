SitemapGenerator::Sitemap.default_host = "https://luniversdessens.com"

SitemapGenerator::Sitemap.create do
  # Pages principales
  add '/courses', changefreq: 'weekly', priority: 0.9
  add '/hikes', changefreq: 'weekly', priority: 0.9
  add '/randonnee', changefreq: 'monthly', priority: 0.8

  # Pages cours de yoga
  Course.where(suspended: [false, nil]).find_each do |course|
    add course_path(course),
        lastmod: course.updated_at,
        changefreq: 'weekly',
        priority: 0.8
  end

  # Pages randonnées yoga
  Hike.find_each do |hike|
    add hike_path(hike),
        lastmod: hike.updated_at,
        changefreq: 'weekly',
        priority: 0.8
  end
end
