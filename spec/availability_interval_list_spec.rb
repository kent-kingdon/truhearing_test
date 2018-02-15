require 'rspec'
require 'availability_interval_list'
describe AvailabilityIntervalList do
  interval_array = %w(8:30 9:00 9:30 10:00 10:30 11:00 11:30 1:00 1:30 2:00 2:30 3:00 3:30 4:00 4:30)
  interval_list = AvailabilityIntervalList.new AvailabilityInterval::DEFAULT_AVAILABILITIES
  describe '#get' do
    it 'returns the current availability list formatted as a 2d array of strings' do
      expect(interval_list.get).to match_array interval_array
    end
  end
  describe '#init_list' do
    it 'takes an array of AvailabilityIntervals and creates an array of all possible intervals from it' do
      interval_list.send(:init_list, AvailabilityInterval::DEFAULT_AVAILABILITIES)
      expect(interval_list.get).to match_array interval_array
    end
  end
  describe '#to_array' do
    it 'parses the interval_list and simplifies it to an array of time intervals' do
      expect(interval_list.to_array).to match_array [
                                                          ['8:30', '9:00'],
                                                          ['9:00', '9:30'],
                                                          ['9:30', '10:00'],
                                                          ['10:00', '10:30'],
                                                          ['10:30', '11:00'],
                                                          ['11:00', '11:30'],
                                                          ['11:30', '12:00'],
                                                          ['1:00', '1:30'],
                                                          ['1:30', '2:00'],
                                                          ['2:00', '2:30'],
                                                          ['2:30', '3:00'],
                                                          ['3:00', '3:30'],
                                                          ['3:30', '4:00'],
                                                          ['4:00', '4:30'],
                                                          ['4:30', '5:00']]
      interval_list.subtract %w(9:00 11:30)
      expect(interval_list.to_array).to match_array [
                                                        ['8:30', '9:00'],
                                                        ['11:30', '12:00'],
                                                        ['1:00', '1:30'],
                                                        ['1:30', '2:00'],
                                                        ['2:00', '2:30'],
                                                        ['2:30', '3:00'],
                                                        ['3:00', '3:30'],
                                                        ['3:30', '4:00'],
                                                        ['4:00', '4:30'],
                                                        ['4:30', '5:00']]
    end
  end
  describe '#subtract' do
    it 'removes all time increments within a given interval range from the interval list' do
      interval_list = AvailabilityIntervalList.new AvailabilityInterval::DEFAULT_AVAILABILITIES
      interval_list.subtract %w(9:00 9:30)
      expect(interval_list.get).to match_array %w(8:30 9:30 10:00 10:30 11:00 11:30 1:00 1:30 2:00 2:30 3:00 3:30 4:00 4:30)
      interval_list.subtract %w(9:00 11:30)
      expect(interval_list.get).to match_array %w(8:30 11:30 1:00 1:30 2:00 2:30 3:00 3:30 4:00 4:30)
      interval_list.subtract %w(10:00 11:00)
      expect(interval_list.get).to match_array %w(8:30 11:30 1:00 1:30 2:00 2:30 3:00 3:30 4:00 4:30)
      interval_list.subtract %w(2:30 3:00)
      expect(interval_list.get).to match_array %w(8:30 11:30 1:00 1:30 2:00 3:00 3:30 4:00 4:30)
    end
  end
end