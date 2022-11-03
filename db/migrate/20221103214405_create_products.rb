class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :categoryId
      t.string :productId

      t.timestamps
    end
  end
end
