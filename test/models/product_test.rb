require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def setup
    @ulf = UploadedFile.new()
    
    @mdp0 = MassDataPoint.new(unit: 'kilogram', mass: 1, uploaded_file: @ulf, product_id: "product0")
    @mdp1 = MassDataPoint.new(unit: 'gram', mass: 10, uploaded_file: @ulf, product_id: "product0")

    @mdp2 = MassDataPoint.new(unit: 'stones', mass: 1, uploaded_file: @ulf, product_id: "product1")
    
    @product0 = Product.new(
      categoryId: "TEST",
      productId: "abc123",
      mass_data_points: [
      @mdp0,
      @mdp1,
    ])

    @product1 = Product.new(
      categoryId: "TEST1",
      productId: "xyz987",
      mass_data_points: [
      @mdp2
    ])

    @ulf.save()
    @mdp0.save()
    @mdp1.save()
    @mdp2.save()
    @product0.save()
    @product1.save()

  end
  
  test 'valid product' do
    assert @product0.valid?
  end

  test 'Product association' do
    assert_equal @product0.mass_data_points, [@mdp0, @mdp1]
    assert_equal @product1.mass_data_points, [@mdp2]
  end

  test 'the App payload' do
    # assert_equal Product.app(), Product.includes(:mass_data_points).all()
    # assert_equal Product.app()[0], @product

    # puts MassDataPoint.all().to_json()
    puts Product.all().to_json #.includes(:mass_data_points).to_json( :include => [:mass_data_points])
  end


end
