require "test_helper"

class UploadedFileTest < ActiveSupport::TestCase
end


class UploadedFileBasicTest < UploadedFileTest
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

class UploadedFileIngestTest < UploadedFileTest
  def setup
    @uploaded_file = UploadedFile.new().ingrest([
      ["2021-03-01 01:30:32.977497+00:00",	"DAY-1A406020000607D000003322", "0.160",	"kilograms"],
      ["2021-03-01 01:30:32.977497+00:00",	"FOO-1A406020000607D000003322", "3",	"stones"],
    ])

  end
  
  test 'valid uploaded_file' do
    assert @uploaded_file.valid?
  end

  test 'simple checks' do
    assert_equal @uploaded_file.mass_data_points[0].unit, "kilograms"
    assert_equal @uploaded_file.mass_data_points[1].unit, "stones"
    assert_equal @uploaded_file.mass_data_points[0].product.productId, "1A406020000607D000003322"
    assert_equal @uploaded_file.mass_data_points[1].product.productId, "1A406020000607D000003322"
    assert_equal @uploaded_file.mass_data_points[0].product.categoryId, "DAY"
    assert_equal @uploaded_file.mass_data_points[1].product.categoryId, "FOO"
  end

end