class AddTimeToCourses < ActiveRecord::Migration[7.2]
  def change
    add_column :courses, :time, :string
  end
end
