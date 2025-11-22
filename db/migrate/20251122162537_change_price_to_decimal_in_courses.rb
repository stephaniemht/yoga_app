class ChangePriceToDecimalInCourses < ActiveRecord::Migration[7.2]
  def change
        change_column :courses, :price, :decimal, precision: 8, scale: 2
  end
end
