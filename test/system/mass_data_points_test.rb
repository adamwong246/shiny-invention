require "application_system_test_case"

class MassDataPointsTest < ApplicationSystemTestCase
  setup do
    @mass_data_point = mass_data_points(:one)
  end

  test "visiting the index" do
    visit mass_data_points_url
    assert_selector "h1", text: "Mass data points"
  end

  test "should create mass data point" do
    visit mass_data_points_url
    click_on "New mass data point"

    fill_in "Mass", with: @mass_data_point.mass
    fill_in "Recordedat", with: @mass_data_point.recordedAt
    fill_in "Unit", with: @mass_data_point.unit
    click_on "Create Mass data point"

    assert_text "Mass data point was successfully created"
    click_on "Back"
  end

  test "should update Mass data point" do
    visit mass_data_point_url(@mass_data_point)
    click_on "Edit this mass data point", match: :first

    fill_in "Mass", with: @mass_data_point.mass
    fill_in "Recordedat", with: @mass_data_point.recordedAt
    fill_in "Unit", with: @mass_data_point.unit
    click_on "Update Mass data point"

    assert_text "Mass data point was successfully updated"
    click_on "Back"
  end

  test "should destroy Mass data point" do
    visit mass_data_point_url(@mass_data_point)
    click_on "Destroy this mass data point", match: :first

    assert_text "Mass data point was successfully destroyed"
  end
end
