class AddFieldsToCourses < ActiveRecord::Migration[7.2]
  def change
    add_column :courses, :duration, :string
    add_column :courses, :price, :integer
  end
end
