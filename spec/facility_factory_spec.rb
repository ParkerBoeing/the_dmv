require 'spec_helper'

RSpec.describe FacilityFactory do
  before(:each) do
  @oregon_facilities = DmvDataService.new.or_dmv_office_locations
  @new_york_facilities = DmvDataService.new.ny_dmv_office_locations
  @missouri_facilities = DmvDataService.new.mo_dmv_office_locations
  @oregon = FacilityFactory.new
  @new_york = FacilityFactory.new
  @missouri = FacilityFactory.new
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

    it 'each instantiated facility from oregon is formatted properly' do
      @oregon.define_facilities(@oregon_facilities)
      expect(@oregon.operating_facilities[0].address).to eq "2242 Santiam Hwy SE Albany OR 97321"
      expect(@oregon.operating_facilities[0].phone).to eq "541-967-2014"
      expect(@oregon.operating_facilities[0].name).to eq "Albany DMV Office"
      expect(@oregon.operating_facilities[1].address).to eq "600 Tolman Creek Rd Ashland OR 97520"
      expect(@oregon.operating_facilities[1].phone).to eq "541-776-6092"
      expect(@oregon.operating_facilities[1].name).to eq "Ashland DMV Office"
      expect(@oregon.operating_facilities.length).to eq @oregon_facilities.length  
    end

    it 'can instantiate facilities from new york' do
      @oregon.define_facilities(@oregon_facilities)
      @new_york.define_facilities(@new_york_facilities)
      expect(@new_york.operating_facilities[0].address).to eq "168-46 91st Ave., 2nd Flr Jamaica NY 11432"
      expect(@new_york.operating_facilities[0].phone).to eq nil
      expect(@new_york.operating_facilities[0].name).to eq "Jamaica Kiosk"
      expect(@new_york.operating_facilities[1].address).to eq "200 E. Main Street Rochester NY 14604"
      expect(@new_york.operating_facilities[1].phone).to eq "585-753-1604"
      expect(@new_york.operating_facilities[1].name).to eq "Rochester Downtown"
      expect(@new_york.operating_facilities.length).to eq @new_york_facilities.length  
    end

    it 'can instantiate facilities from missouri' do
      @oregon.define_facilities(@oregon_facilities)
      @new_york.define_facilities(@new_york_facilities)
      @missouri.define_facilities(@missouri_facilities)
      expect(@missouri.operating_facilities[0].address).to eq "3164 Telegraph Road St Louis MO 63125"
      expect(@missouri.operating_facilities[0].phone).to eq "314-887-1050"
      expect(@missouri.operating_facilities[0].name).to eq "Oakville"
      expect(@missouri.operating_facilities[1].address).to eq "30 N Allen St Bonne Terre MO 63628"
      expect(@missouri.operating_facilities[1].phone).to eq "573-358-3584"
      expect(@missouri.operating_facilities[1].name).to eq "Bonne Terre"
      expect(@missouri.operating_facilities.length).to eq @missouri_facilities.length  
    end

    it 'can list daily hours for NY and MO facilities' do
      @new_york.define_facilities(@new_york_facilities)
      @missouri.define_facilities(@missouri_facilities)
      expect(@new_york.operating_facilities[0].operating_hours).to eq "Monday-friday - 7:30 To 5:00 Sat & Sun - Closed"
      expect(@new_york.operating_facilities[1].operating_hours).to eq "Monday-friday - 9:00 To 5:00 Sat & Sun - Closed"
      expect(@missouri.operating_facilities[0].operating_hours).to eq "Monday-friday - 9:00 To 5:00, Last Saturday - 9:00 To 12:00"
      expect(@missouri.operating_facilities[1].operating_hours).to eq "Monday-friday - 9:00 To 5:00, Last Saturday - 9:00 To 1:00, 1st & Last Business Day Of Month - 8:30 To 5:30"
    end

    it 'can list holiday closures in MO' do
      @missouri.define_facilities(@missouri_facilities)
      expect(@missouri.operating_facilities[0].holiday_closures).to eq "Thanksgiving (11/24/22), Christmas Day Observed (12/26/22), New Year's Day Observed (01/02/23), Martin Luther King Day (01/16/23), President’s Day (02/20/23), Memorial Day (05/29/23), Juneteenth (06/19/2023), Independence Day (07/04/23), Labor Day (09/04/23), Veterans Day (11/10/23), Thanksgiving (11/23/23), Christmas Day Observed (12/25/23)"
      expect(@missouri.operating_facilities[1].holiday_closures).to eq "Independence Day (07/04/22), Labor Day (09/05/22), Columbus Day (10/10/22), Veterans Day (11/11/22), Thanksgiving (11/24/22), Christmas Day Observed (12/26/22), New Year's Day Observed (01/02/23), Martin Luther King Day (01/16/23), President’s Day (02/20/23), Memorial Day (05/29/23), Juneteenth (06/19/2023), Independence Day (07/04/23), Labor Day (09/04/23), Columbus Day (10/09/23), Veterans Day (11/10/23), Thanksgiving (11/23/23), Christmas Day Observed (12/25/23)"
    end
  end
end
