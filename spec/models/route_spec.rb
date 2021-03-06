require 'rails_helper'

RSpec.describe Route, :type => :model do

  describe "associations" do
    it { should belong_to :airline }
    it { should belong_to :origin_airport }
    it { should belong_to :destination_airport }
    it { should have_many(:users).through(:route_users) }
  end

  describe "validations" do
    it { should validate_presence_of :origin_airport_id }
    it { should validate_presence_of :destination_airport_id }
    it { should validate_presence_of :airline_id }
    it { should validate_presence_of :origin_airport }
    it { should validate_presence_of :destination_airport }
    it { should validate_presence_of :airline }
  end

  describe "functions" do

    before do
      create(:airline)
      @origin = create(:airport, latitude:40, longitude:45, iata_faa:"JFK")
      @destination = create(:airport, latitude:50, longitude:55, iata_faa:"BOS")
      @route = create(:route)
    end

    describe "responses" do
      it { should respond_to :airline }
      it { should respond_to :origin_airport }
      it { should respond_to :origin }
      it { should respond_to :destination_airport }
      it { should respond_to :destination }
    end

    describe "aliases" do
      before { @route = create(:route) }
      
      it "should allow #origin as short for #origin_airport" do
        expect(@route.origin).to eq(@route.origin_airport)
      end

      it "should allow #destination as short for #destination_airport" do
        expect(@route.destination).to eq(@route.destination_airport)
      end
    end

    describe "coordinates" do
      it "should return the coordinates of the origin and destination airport" do
        expect(@route.coordinates).to eq([[40, 45],[50, 55]])
      end
    end

    describe "airports" do
      it "should return the origin and destination airports" do
        expect(@route.airports).to eq([@origin, @destination])
      end
    end

    describe "map_line" do
      it "should return an array of hashs for using in gmaps" do
        expect(@route.map_line).to eq([{lat:40, lng:45},{lat:50, lng:55}])
      end
    end

    describe "distance" do
      it "should return the distance in miles" do
        expect(@route.distance).to be_within(10.0).of(844.443)
      end
      it "should return the distance in kilometers" do
        expect(@route.distance(:km)).to be_within(10.0).of(1359.0)
        expect(@route.distance(:kilometer)).to be_within(10.0).of(1359)
      end
      it "should return the distance in nautical miles" do
        expect(@route.distance(:nm)).to be_within(10.0).of(733.8)
        expect(@route.distance(:nautical_mile)).to be_within(10.0).of(733.8)
      end
      it "should save the new distance to the route in miles when called with '!'" do
        @route.distance!
        @route.save!
        expect(@route.miles).to be_within(10.0).of(844.443)
      end
    end

  end

  describe "factories" do

    before do
      @airline = create(:airline)
      @airport1 = create(:airport)
      @airport2 = create(:airport, iata_faa:"JFK", icao:"KJFK")
    end

    it "has a valid factory" do
      @route = build(:route)
      expect(@route).to be_valid
    end

    it "has an invalid factory" do
      @route = build(:invalid_route)
      expect(@route).to_not be_valid
    end

  end

end
