class Product < ApplicationRecord
  has_many :mass_data_points

  def self.app()
    Product.all()
    .includes(:mass_data_points)
    .group_by{|p| p.categoryId }
    .map { |categoryName, productsWithMassDataPoints| 
      [
      categoryName, 
      productsWithMassDataPoints.map {|productWithMassDataPoints|
        
        productWithMassDataPointsToReturn = productWithMassDataPoints.as_json

        productWithMassDataPointsToReturn[:mass_data_points] = productWithMassDataPoints.mass_data_points.map{|mdp|
          toReturn = mdp.as_json
          toReturn[:kilograms] = 99
          toReturn
        }

        productWithMassDataPointsToReturn[:total_kilograms] = productWithMassDataPointsToReturn[:mass_data_points]
        .reduce(0) {|memo, mdp|
          memo + mdp[:kilograms]
        }

        productWithMassDataPointsToReturn
      }
    ]}
  end
end
