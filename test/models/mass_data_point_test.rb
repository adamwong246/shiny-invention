require "test_helper"

class MassDataPointTest < ActiveSupport::TestCase
  def setup
    @uploadedFile = UploadedFile.new()
    @product = Product.new()
    @massDataPoint = MassDataPoint.new(unit: 'gram', mass: 1, uploaded_file: @uploadedFile, product: @product)
  end
  
  test 'valid mpd' do
    assert @massDataPoint.valid?
  end

  test 'Product association' do
    assert_equal @massDataPoint.product, @product
  end

  test 'Uploaded File association' do
    assert_equal @massDataPoint.uploaded_file, @uploadedFile
  end
end
