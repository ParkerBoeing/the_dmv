require 'spec_helper'

RSpec.describe FacilityFactory do
  before(:each) do
  @oregon_facilities = DmvDataService.new.or_dmv_office_locations
  @new_york_facilities = DmvDataService.new.ny_dmv_office_locations
  @missouri_facilities = DmvDataService.new.mo_dmv_office_locations
  @oregon = FacilityFactory.new
  end
  
  describe '#initialize' do
    it 'can initialize' do
      expect(@oregon).to be_a FacilityFactory
    end
  end

  describe '#define_facilities' do
    it 'can put the facilities of oregon into an array' do
      expect(@oregon.operating_facilities).to eq []
      @oregon.define_facilities(@oregon_facilities)
      expect(@oregon.operating_facilities).to include(Facility)
   
    end

    it 'each instantiated facility is formatted properly' do
      @oregon.define_facilities(@oregon_facilities)
      expect(@oregon.operating_facilities[0].address).to eq "2242 Santiam Hwy SE Albany OR 97321"
      expect(@oregon.operating_facilities[0].phone).to eq "541-967-2014"
      expect(@oregon.operating_facilities[0].name).to eq "Albany DMV Office"
      expect(@oregon.operating_facilities[1].address).to eq "600 Tolman Creek Rd Ashland OR 97520"
      expect(@oregon.operating_facilities[1].phone).to eq "541-776-6092"
      expect(@oregon.operating_facilities[1].name).to eq "Ashland DMV Office"
      expect(@oregon.operating_facilities.length).to eq @oregon_facilities.length  
    end
  end
end
