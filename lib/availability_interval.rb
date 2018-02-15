require 'time'

class AvailabilityInterval

  DEFAULT_AVAILABILITIES = [%w(8:30 11:30), %w(1:00 4:30)]

  attr_accessor :start_time, :end_time

  def initialize (interval)
    @interval   = interval
    @start_time = Time.parse AvailabilityInterval.add_am_pm interval[0]
    @end_time   = Time.parse AvailabilityInterval.add_am_pm interval[1]
    @min_limit  = AvailabilityInterval.add_am_pm DEFAULT_AVAILABILITIES[0][0]
    @max_limit  = AvailabilityInterval.add_am_pm DEFAULT_AVAILABILITIES[1][1]
  end

  def get
    @interval
  end

  def valid_interval?
    unless interval_start_before_end?
      raise InvalidTimeInterval, 'The interval must have a start time less than the end time'
    end
    unless interval_in_range?
      raise InvalidTimeInterval, 'The time interval supplied is outside of the availability range'
    end
    unless interval_30_min_increment?
      raise InvalidTimeInterval, 'Your interval has a start or end time that doesn\'t land in a 30 minute increment'
    end
    true
  end

  def interval_start_before_end?
    @start_time.to_i < @end_time.to_i
  end

  def interval_in_range?
    ((Time.parse(@min_limit).to_i <= @start_time.to_i) && (@end_time.to_i <= Time.parse(@max_limit).to_i))
  end

  def interval_30_min_increment?
    start_min = @start_time.min
    end_min   = @end_time.min
    (start_min == 30 || start_min == 0) && (end_min == 30 || end_min == 0)
  end

  def self.add_am_pm(time_string)
    am_hours = [8, 9, 10, 11]
    pm_hours = [12, 1, 2, 3, 4, 5]
    new_time_string = ''
    hour = Time.parse(time_string).hour
    if am_hours.include? hour
       new_time_string = time_string + 'am'
    elsif pm_hours.include? hour
       new_time_string = time_string + 'pm'
    end
    new_time_string
  end

  private :valid_interval?,
          :interval_start_before_end?,
          :interval_in_range?,
          :interval_30_min_increment?
end

class InvalidTimeInterval < StandardError
  def initialize(message)
    super
  end
end