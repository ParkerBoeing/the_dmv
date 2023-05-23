class FacilityFactory
  attr_reader :operating_facilities

  def initialize
    @operating_facilities = []
  end

  def define_facilities(facilities)
    facilities.each do |facility_data|
      if facility_data[:location_1].is_a?(Hash)
        address_data = JSON.parse(facility_data[:location_1][:human_address], symbolize_names: true)
        facility = Facility.new({
          name: capitalize_words(facility_data[:title]),
          address: capitalize_words("#{address_data[:address]} #{address_data[:city]} #{address_data[:state]} #{address_data[:zip]}"),
          phone: facility_data[:phone_number]
        })
        @operating_facilities << facility
      elsif facility_data[:state] == "NY"
        facility = Facility.new({
          name: capitalize_words(facility_data[:office_name]),
          address: capitalize_words("#{facility_data[:street_address_line_1]} #{facility_data[:city]} #{facility_data[:state]} #{facility_data[:zip_code]}"),
          phone: format_phone_number(facility_data[:public_phone_number]),
          operating_hours: if facility_data[:monday_beginning_hours] == facility_data[:tuesday_beginning_hours] &&
                              facility_data[:tuesday_beginning_hours] == facility_data[:wednesday_beginning_hours] &&
                              facility_data[:wednesday_beginning_hours] == facility_data[:thursday_beginning_hours] &&
                              facility_data[:thursday_beginning_hours] == facility_data[:friday_beginning_hours] &&
                              facility_data[:monday_ending_hours] == facility_data[:tuesday_ending_hours] &&
                              facility_data[:tuesday_ending_hours] == facility_data[:wednesday_ending_hours] &&
                              facility_data[:wednesday_ending_hours] == facility_data[:thursday_ending_hours] &&
                              facility_data[:thursday_ending_hours] == facility_data[:friday_ending_hours]
                              capitalize_operating_hours("Monday-friday - #{facility_data[:monday_beginning_hours]} to #{facility_data[:monday_ending_hours]}, Sat & Sun - Closed")
          else
            capitalize_operating_hours("Monday - #{facility_data[:monday_beginning_hours]} to #{facility_data[:monday_ending_hours]}, " +
            "Tuesday - #{facility_data[:tuesday_beginning_hours]} to #{facility_data[:tuesday_ending_hours]}, " +
            "Wednesday - #{facility_data[:wednesday_beginning_hours]} to #{facility_data[:wednesday_ending_hours]}, " +
            "Thursday - #{facility_data[:thursday_beginning_hours]} to #{facility_data[:thursday_ending_hours]}, " +
            "Friday - #{facility_data[:friday_beginning_hours]} to #{facility_data[:friday_ending_hours]}, " +
            "Sat & Sun - Closed")
          end
        })
        @operating_facilities << facility
      elsif facility_data[:state] == "MO"
        facility = Facility.new({
          name: capitalize_words(facility_data[:name]),
          address: capitalize_words("#{facility_data[:address1]} #{facility_data[:city]} #{facility_data[:state]} #{facility_data[:zipcode]}"),
          phone: format_phone_number(facility_data[:phone]),
          operating_hours: capitalize_operating_hours(facility_data[:daysopen]),
          holiday_closures: facility_data[:holidaysclosed]
        })
        @operating_facilities << facility
      else
        p "Invalid input, please use list of facilities from relevant states as argument."
      end
    end
    @operating_facilities
  end

  def capitalize_words(string)
    excluded_words = ["DMV", "OR", "NY", "MO", "SE", "NE", "SW", "NW"]
    words = string.split.map do |word|
      if excluded_words.include?(word)
        word
      else
        word.capitalize
      end
    end
    words.join(" ")
  end

  def capitalize_operating_hours(hours)
    if hours
      words = hours.split.map do |word| 
        if word == "AM" || word == "PM,"
          nil
        else
          word.capitalize
        end
      end
      words.compact.join(" ")
    else
      nil
    end
  end

  def format_phone_number(phone)
    return nil if phone.nil?
    digits = phone.gsub(/\D/, '')
    formatted_number = "#{digits[0..2]}-#{digits[3..5]}-#{digits[6..9]}"
    formatted_number
  end
end