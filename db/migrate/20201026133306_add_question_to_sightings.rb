class AddQuestionToSightings < ActiveRecord::Migration[6.0]
  def change
    add_column :sightings, :question, :jsonb, null: false, default: '{}'
  end
end
