class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.references :user, foreign_key: true, index: true
      t.references :sighting, foreign_key: true, index: true

      t.timestamps
    end
  end
end
