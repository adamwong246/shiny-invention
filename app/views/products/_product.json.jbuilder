json.extract! product, :id, :categoryId, :productId, :created_at, :updated_at, :mass_data_points
json.url product_url(product, format: :json)