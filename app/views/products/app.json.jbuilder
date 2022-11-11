# json.obj
# json.category @products do |product|
#   json.id product.id
# #   json.mass_data_points product.mass_data_points do |mass_data_point|
# #     json.id mass_data_point.id
# #     json.id mass_data_point.id
# #   # json.monuments category.monuments do |monument|
# #   #   json.name monument.name
# #   #   json.id monument.id
# #   #   json.pois monument.pois do |p|
# #   #     json.name p.name
# #   #   end
# #   end
# end

json.array! @APP#, partial: "products/product", as: :product

# json.extract! @APP, :id, :categoryId, :productId, :created_at, :updated_at, :mass_data_points
# json.url product_url(product, format: :json)

# json.results do |json|
#   yield
# end