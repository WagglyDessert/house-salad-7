require 'rails_helper'

feature "user can search for house members" do
  scenario "user submits valid state name" do

    json_response = File.read("spec/fixtures/house_members_colorado.json")

    stub_request(:get, "https://api.propublica.org/congress/v1/members/house/CO/current.json").
    with(
      headers: {
     'Accept'=>'*/*',
     'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
     'User-Agent'=>'Faraday v2.7.12',
     'X-Api-Key'=> Rails.application.credentials.propublica[:key]
      }).
    to_return(status: 200, body: json_response, headers: {})
    # As a user
    # When I visit "/"
    visit '/'

    select "Colorado", from: :state
    # And I select "Colorado" from the dropdown
    click_on "Locate Members of the House"
    # And I click on "Locate Members from the House"
    expect(current_path).to eq(search_path)
    # Then my path should be "/search" with "state=CO" in the parameters
    expect(page).to have_content("8 Results")
    # And I should see a message "8 Results"
    expect(page).to have_css(".member", count: 8)
    # And I should see a list of 8 the members of the house for Colorado

    within(first(".member")) do
      expect(page).to have_css(".name")
      expect(page).to have_css(".role")
      expect(page).to have_css(".party")
      expect(page).to have_css(".district")
    end
    # And I should see a name, role, party, and district for each member
  end
end