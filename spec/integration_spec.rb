require 'rubygems'
require File.join(File.dirname(__FILE__),'spec_helper')
require 'activerecord'
require 'ar_measurement_attributes'

class Automobile < ActiveRecord::Base
  percentage :urbanity
  length :weekly_distance_estimate
  price :weekly_cost_estimate
end

class Boat < ActiveRecord::Base
  length :weekly_distance_estimate, :external => :nautical_miles # override default external unit
end

class Candy < ActiveRecord::Base
  price :price, :precision => 2 # override default precision
end

describe ARMeasurementAttributes do
  def automobile
    @automobile ||= Automobile.create(
      :urbanity => 0.74999999999999999999999,
      :weekly_distance_estimate => 16.09344,
      :weekly_cost_estimate => 45.0)
  end
  def boat
    @boat ||= Boat.create(:weekly_distance_estimate => 20)
  end
  def candy
    @candy ||= Candy.create(:price => 12)
  end

  it 'should save measurements in metric units' do
    automobile.urbanity.should be_close(0.74999999999999999999999, 0.001)
    automobile.weekly_distance_estimate(:metric).should == 16.09344
    automobile.weekly_cost_estimate.should == 45.0

    boat.weekly_distance_estimate(:ugly).should == 20

    candy.price.should == 12.0
  end
  it 'should display measurements in imperial units' do
    automobile.urbanity(:pretty).should == "75%"
    automobile.weekly_distance_estimate(:pretty => true).should == "10 miles"
    automobile.weekly_cost_estimate(true).should == "$45.00"

    boat.weekly_distance_estimate(:pretty).should == "10.8 nautical miles"

    candy.price(:pretty).should == "$12.00"
  end
end
