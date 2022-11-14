class Product < ApplicationRecord
  has_many :mass_data_points
  has_many :uploaded_files, -> { distinct }, through: :mass_data_points

  def self.app()
    Product.all()
    .group_by{|p| p.categoryId }  
    .map { |categoryName, productsWithMassDataPoints| 
        productsInCategory = productsWithMassDataPoints.map {|productWithMassDataPoints|
        productWithMassDataPointsToReturn = productWithMassDataPoints.as_json
        productWithMassDataPointsToReturn[:mass_data_point_summation] = productWithMassDataPoints
        .mass_data_points
        .map{|mdp|
          {
            mdpId: mdp.id,
            converted_kilograms: Measured::Weight.new(mdp.mass, mdp.unit).convert_to("kg").value,
            earliest_record_of_import: mdp.uploaded_file.mass_data_points.reduce(Time.now){ |memo2, mdp2|
            if (mdp2.recordedAt < memo2)
              mdp2.recordedAt
             else 
              memo2
            end
          }
          }
        }
        
        productWithMassDataPointsToReturn[:total_converted_kilograms_of_single_product] = productWithMassDataPointsToReturn[:mass_data_point_summation]
        .reduce(0) {|memo, mdp|
          memo + mdp[:converted_kilograms]
        }

        productWithMassDataPointsToReturn[:earliest] = productWithMassDataPointsToReturn[:mass_data_point_summation]
        .reduce(Time.now) {|mm, lm|
          if (lm[:earliest_record_of_import] < mm)
              lm[:earliest_record_of_import]
             else 
              mm
            end
        }
        
        productWithMassDataPointsToReturn
      }

      Hash[
      categoryName, 
      {
        total_converted_kilograms_of_products_incategory: productsInCategory.reduce(0) { |mm, lm|
          mm + lm[:total_converted_kilograms_of_single_product]
        },

        productsInCategory: productsInCategory
      }
    ]}
    .reduce({}) { |mm, lm|
      mm.merge(lm)
    }
  end
end
