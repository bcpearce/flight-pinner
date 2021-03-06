require 'rails_helper'

describe "selecting airport by IATA/FAA code" do

  before do
    @airport = create(:airport, iata_faa:"JFK")
  end

  context "valid" do
    it "returns the airport page" do
      visit airports_path
      fill_in 'iata_faa_search', with: "JFK"
      click_button 'Find'
      expect(current_path).to eq(airport_path @airport)
    end
  end

  context "invalid" do

    before do
      visit airports_path
      fill_in 'iata_faa_search', with: "BOS"
      click_button 'Find'
    end

    it "redirects back to #index" do
      expect(current_path).to eq(airports_path)
    end

    it "updates the flash" do
      expect(page).to have_content("Invalid IATA/FAA code!")
    end

  end
end

describe "flights departing from the airport" do

  before do
    @origin_airport = create(:airport, iata_faa:"JFK")
    @destination_airport = create(:airport, iata_faa:"BOS")
    @airline = create(:airline)
    @routes = [create(:route), create(:route)]
    visit '/airports/1'
  end

  it "should have a link for viewing the routes that leave" do
    expect(page).to have_link("Departing Routes", href:'/airports/1/routes')
  end

  describe "airports/:id/routes" do
    it "should be accessible from 'airports/:id'" do
      click_link("Departing Routes")
      @origin_airport.departing_flights.each do |route|
        expect(page).to have_content(route.destination_airport.iata_faa)
        expect(page).to have_content(route.origin_airport.iata_faa)
        expect(page).to have_content(route.airline.name)
      end
    end

    describe "selecting a flight to log" do
      before do
        visit '/airports/1/routes'
        click_link_or_button("route_1")
      end
      it "should open a '/routes_users/new' with the route info shown" do
        expect(page).to have_content(@routes[0].origin_airport.iata_faa)
        expect(page).to have_content(@routes[0].destination_airport.iata_faa)
        expect(page).to have_content(@routes[0].airline.name)
      end
    end
  end

  after do |example|
    if example.exception != nil
      save_and_open_page
    end
  end

end
