class CreatePresentations < ActiveRecord::Migration[7.2]
  def change
    create_table :presentations do |t|
      t.text :content
      t.string :photo

      t.timestamps
    end
  end
end

