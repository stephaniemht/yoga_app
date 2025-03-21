class AddTimeToHikes < ActiveRecord::Migration[7.2]
  def change
    add_column :hikes, :time, :time
  end
end
