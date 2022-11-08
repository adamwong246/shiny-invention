require "test_helper"

class UploadedFileTest < ActiveSupport::TestCase
  def setup
    @mdp0 = MassDataPoint.new(unit: 'kilogram', mass: 1)
    @mdp1 = MassDataPoint.new(unit: 'gram', mass: 10)

    @product = Product.new(mass_data_points: [
      @mdp0,
      @mdp1,
    ])

    @uploadedFile = UploadedFile.new(mass_data_points: [
      @mdp0,
      @mdp1,
    ])
  end
  
  test 'valid uploadedFile' do
    assert @uploadedFile.valid?
  end

  test 'mass_data_points association' do
    assert_equal @uploadedFile.mass_data_points, [@mdp0, @mdp1]
  end
end
