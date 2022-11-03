class CreateMassDataPoints < ActiveRecord::Migration[7.0]
  def change
    create_table :mass_data_points do |t|
      t.timestamp :recordedAt
      t.decimal :mass
      t.string :unit

      t.timestamps
    end
  end
end
