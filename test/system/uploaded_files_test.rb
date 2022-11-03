require "application_system_test_case"

class UploadedFilesTest < ApplicationSystemTestCase
  setup do
    @uploaded_file = uploaded_files(:one)
  end

  test "visiting the index" do
    visit uploaded_files_url
    assert_selector "h1", text: "Uploaded files"
  end

  test "should create uploaded file" do
    visit uploaded_files_url
    click_on "New uploaded file"

    click_on "Create Uploaded file"

    assert_text "Uploaded file was successfully created"
    click_on "Back"
  end

  test "should update Uploaded file" do
    visit uploaded_file_url(@uploaded_file)
    click_on "Edit this uploaded file", match: :first

    click_on "Update Uploaded file"

    assert_text "Uploaded file was successfully updated"
    click_on "Back"
  end

  test "should destroy Uploaded file" do
    visit uploaded_file_url(@uploaded_file)
    click_on "Destroy this uploaded file", match: :first

    assert_text "Uploaded file was successfully destroyed"
  end
end
