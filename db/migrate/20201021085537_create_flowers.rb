class CreateFlowers < ActiveRecord::Migration[6.0]
  def change
    create_table :flowers do |t|
      t.string :name, null: false, index: { unique: true }
      t.text :description

      t.timestamps
    end
  end
end
