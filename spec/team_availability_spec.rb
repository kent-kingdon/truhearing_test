require 'rspec'
require 'team_availability'

describe '#team_availability' do
  it 'takes a list of availability intervals and gives back the times all are available' do
    expect(team_availability([['9:00', '9:30'], ['9:00', '11:30'], ['10:00', '11:00'], ['2:30', '3:00'], ['2:30', '3:30']])).to match_array [['8:30', '9:00'], ['11:30', '12:00'], ['1:00', '1:30'], ['1:30', '2:00'], ['2:00', '2:30'], ['3:30', '4:00'], ['4:00', '4:30'], ['4:30', '5:00']]
  end
end