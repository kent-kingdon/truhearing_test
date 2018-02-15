require 'rspec'
require 'availability_interval'




describe AvailabilityInterval do
  #----TEST CASES----
  valid_time_interval = %w(9:00 9:30)
  invalid_time_intervals = {
    :end_before_start     => %w(10:30 9:30),
    :out_of_range         => %w(8:00 8:30),
    :during_lunch         => %w(12:00 12:30),
    :not_30_min_increment => %w(2:20 1:15)
  }
  valid_interval = AvailabilityInterval.new (valid_time_interval)
  #------------------
  describe '#get' do
    it 'stores the time interval for recall' do
      expect(valid_interval.get).to equal valid_time_interval
    end
  end
  describe '#valid_interval?' do
    context 'when passed a valid interval' do
      it ('returns true') do
        expect(valid_interval.send(:valid_interval?)).to be true
      end
    end
    context 'when passed an invalid interval' do
      it ('will throw an invalid interval error') do
        invalid_time_intervals.each do |reason, example|
          availability_interval = AvailabilityInterval.new (example)
          expect(availability_interval.send(:valid_interval?)).to raise_error(InvalidTimeInterval)
        end
      end
    end
  end
  describe '#interval_start_before_end?' do
    it 'checks to see if an interval\'s start time is before its end time' do
      expect(valid_interval.send(:interval_start_before_end?)).to be true
      availability_interval = AvailabilityInterval.new (invalid_time_intervals[:end_before_start])
      expect(availability_interval.send(:interval_start_before_end?)).to be false
    end
  end
  describe '#interval_in_range?' do
    it 'checks to see if an interval is in the range of intervals in DEFAULT_AVAILABILITIES' do
      expect(valid_interval.send(:interval_in_range?)).to be true
      availability_interval = AvailabilityInterval.new (invalid_time_intervals[:out_of_range])
      expect(availability_interval.send(:interval_in_range?)).to be false
    end
  end
  describe '#interval_30_min_increment?' do
    it 'checks to see if an interval ends in 30 or 00' do
      expect(valid_interval.send(:interval_30_min_increment?)).to be true
      availability_interval = AvailabilityInterval.new (invalid_time_intervals[:not_30_min_increment])
      expect(availability_interval.send(:interval_30_min_increment?)).to be false
    end
  end
  describe '#self.add_am_pm' do
    it 'adds am and pm to times passed based on a normal business day of 8:30-5:00' do
      expect(AvailabilityInterval.add_am_pm "9:00").to eq "9:00am"
      expect(AvailabilityInterval.add_am_pm "12:00").to eq "12:00pm"
    end
  end
end