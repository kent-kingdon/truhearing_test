require 'availability_interval'
require 'availability_interval_list'
def team_availability(availabilities = [])

  team_availability_list = AvailabilityIntervalList.new AvailabilityInterval::DEFAULT_AVAILABILITIES
  availabilities.each do |booked_interval|
    team_availability_list.subtract(booked_interval)
  end
  team_availability_list.to_array
end