require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def setup
    @ulf = UploadedFile.new()
    @mdp0 = MassDataPoint.new(unit: 'kilogram', mass: 1, uploaded_file: @ulf)
    @mdp1 = MassDataPoint.new(unit: 'gram', mass: 10, uploaded_file: @ulf)
    
    @product = Product.new(mass_data_points: [
      @mdp0,
      @mdp1,
    ])
  end
  
  test 'valid product' do
    assert @product.valid?
  end

  test 'Product association' do
    assert_equal @product.mass_data_points, [@mdp0, @mdp1]
  end

end
