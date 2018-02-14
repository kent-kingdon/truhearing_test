require 'pry'
require 'availability_interval'

class AvailabilityIntervalList
  DEFAULT_INTERVAL_IN_MINUTES = 30

  def initialize(availability_intervals)
    @interval_list = init_list(availability_intervals)
  end

  def get
    @interval_list
  end

  def init_list(availability_intervals)
    interval_list = []
    availability_intervals.each do |interval|
      availability_interval = AvailabilityInterval.new interval
      (availability_interval.start_time.to_i..availability_interval.end_time.to_i).step(DEFAULT_INTERVAL_IN_MINUTES * 60) do |increment|
        interval_list << Time.at(increment).strftime('%l:%M').strip
      end
    end
    interval_list
  end

  def to_array
    []
  end

  def subtract(interval)

  end

  private :init_list
end