class AddFieldsToHikes < ActiveRecord::Migration[7.2]
  def change
    add_column :hikes, :end_date, :datetime
    add_column :hikes, :price, :integer
  end
end
