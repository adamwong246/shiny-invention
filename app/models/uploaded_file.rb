class UploadedFile < ApplicationRecord
  has_many :mass_data_points

  has_one_attached :source_csv_file

end
