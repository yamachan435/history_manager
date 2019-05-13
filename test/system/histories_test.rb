require "application_system_test_case"

class HistoriesTest < ApplicationSystemTestCase
  setup do
    @history = histories(:one)
  end

  test "visiting the index" do
    visit histories_url
    assert_selector "h1", text: "Histories"
  end

  test "creating a History" do
    visit histories_url
    click_on "New History"

    fill_in "Action", with: @history.action
    fill_in "Balance", with: @history.balance
    fill_in "Console", with: @history.console
    fill_in "Date", with: @history.date
    fill_in "In station", with: @history.in_station
    fill_in "In station line", with: @history.in_station_line
    fill_in "Out station", with: @history.out_station
    fill_in "Out station line", with: @history.out_station_line
    click_on "Create History"

    assert_text "History was successfully created"
    click_on "Back"
  end

  test "updating a History" do
    visit histories_url
    click_on "Edit", match: :first

    fill_in "Action", with: @history.action
    fill_in "Balance", with: @history.balance
    fill_in "Console", with: @history.console
    fill_in "Date", with: @history.date
    fill_in "In station", with: @history.in_station
    fill_in "In station line", with: @history.in_station_line
    fill_in "Out station", with: @history.out_station
    fill_in "Out station line", with: @history.out_station_line
    click_on "Update History"

    assert_text "History was successfully updated"
    click_on "Back"
  end

  test "destroying a History" do
    visit histories_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "History was successfully destroyed"
  end
end
