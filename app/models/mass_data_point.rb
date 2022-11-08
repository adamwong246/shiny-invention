class MassDataPoint < ApplicationRecord
  belongs_to :product
  belongs_to :uploaded_file
end
