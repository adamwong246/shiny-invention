class AddAssociations < ActiveRecord::Migration[7.0]
  def change
    add_reference(:mass_data_points, :product)
    add_reference(:mass_data_points, :uploaded_file)

    # add_reference(:uploaded_files, :mass_data_points)
    # add_reference(:products, :mass_data_points)
  end
end
