class UploadedFile < ApplicationRecord
  has_many :mass_data_points

  has_one_attached :source_csv_file

  def ingrest(lines)

    lines.each_with_index do |row, index|

      timestampDatum = row[0]
      productAndCategoryDatum = row[1]
      weightDatum = row[2]
      unitDatum = row[3]

      splited = productAndCategoryDatum.split('-')
      categoryId = splited[0]
      productId = splited[1]

      self.mass_data_points << MassDataPoint.new(
        unit: unitDatum, 
        mass: weightDatum,
        recordedAt: timestampDatum,
        product: Product.find_or_initialize_by(productId: productId, categoryId: categoryId),
      );

    end

    return self

  end
end
