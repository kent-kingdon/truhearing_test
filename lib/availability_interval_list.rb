require 'availability_interval'
require 'pry'
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
    interval_array    = []
    @interval_list.each do |time|
      start_time = Time.parse(AvailabilityInterval.add_am_pm time)
      end_time = start_time + (DEFAULT_INTERVAL_IN_MINUTES * 60)
      interval_array << [Time.at(start_time).strftime('%l:%M').strip, Time.at(end_time).strftime('%l:%M').strip]
    end
    interval_array
  end

  def subtract(interval)
    start_time = Time.parse(AvailabilityInterval.add_am_pm interval[0])
    end_time   = Time.parse(AvailabilityInterval.add_am_pm interval[1])
    (start_time.to_i..end_time.to_i - (DEFAULT_INTERVAL_IN_MINUTES * 60)).step(DEFAULT_INTERVAL_IN_MINUTES * 60) do |increment|
      formatted_time = Time.at(increment).strftime('%l:%M').strip
      @interval_list -= [formatted_time]
    end
    nil
  end

  private :init_list
end