require "test_helper"

class MassDataPointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mass_data_point = mass_data_points(:one)
  end

  # test "should get index" do
  #   get mass_data_points_url
  #   assert_response :success
  # end

  # test "should get new" do
  #   get new_mass_data_point_url
  #   assert_response :success
  # end

  # test "should create mass_data_point" do
  #   assert_difference("MassDataPoint.count") do
  #     post mass_data_points_url, params: { mass_data_point: { mass: @mass_data_point.mass, recordedAt: @mass_data_point.recordedAt, unit: @mass_data_point.unit } }
  #   end

  #   assert_redirected_to mass_data_point_url(MassDataPoint.last)
  # end

  # test "should show mass_data_point" do
  #   get mass_data_point_url(@mass_data_point)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_mass_data_point_url(@mass_data_point)
  #   assert_response :success
  # end

  # test "should update mass_data_point" do
  #   patch mass_data_point_url(@mass_data_point), params: { mass_data_point: { mass: @mass_data_point.mass, recordedAt: @mass_data_point.recordedAt, unit: @mass_data_point.unit } }
  #   assert_redirected_to mass_data_point_url(@mass_data_point)
  # end

  # test "should destroy mass_data_point" do
  #   assert_difference("MassDataPoint.count", -1) do
  #     delete mass_data_point_url(@mass_data_point)
  #   end

  #   assert_redirected_to mass_data_points_url
  # end
end
