require 'rubygems'
require File.join(File.dirname(__FILE__),'spec_helper')
require 'activerecord'
require 'ar_measurement_attributes'

ARMeasurementAttributes.configure_units do |conf|
  conf.define :area                  :internal => :square_metres,         :external => :square_feet
  conf.define :biomass               :internal => :joules,                :external => :cords
  conf.define :cost                  :internal => :dollars,               :external => :dollars           # according to tradition should be cents
  conf.define :length                :internal => :kilometres,            :external => :miles             # according to SI should be in metres
  conf.define :length_per_volume     :internal => :kilometres_per_litre,  :external => :miles_per_gallon
  conf.define :mass                  :internal => :kilograms,             :external => :pounds
  conf.define :electrical_energy     :internal => :kilowatt_hours,        :external => :kilowatt_hours
  conf.define :speed                 :internal => :kilometres_per_hour,   :external => :miles_per_hour
  conf.define :time                  :internal => :hours,                 :external => :hours             # according to SI should be seconds
  conf.define :volume                :internal => :litres,                :external => :gallons
end

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
    @automobile ||= Automobile.new(
      :urbanity => 0.74999999999999999999999,
      :weekly_distance_estimate => 16.09344,
      :weekly_cost_estimate => 45.0)
  end
  def boat
    @boat ||= Boat.new(:weekly_distance_estimate => 20)
  end
  def candy
    @candy ||= Candy.new(:price => 12)
  end

  it 'should save measurements in metric units' do
    automobile.urbanity.should be_close(0.74999999999999999999999, 0.001)
    automobile.weekly_distance_estimate.should == 16.09344
    automobile.weekly_cost_estimate.should == 45.0

    boat.weekly_distance_estimate.should == 20

    candy.price.should == 12.0
  end
  it 'should display measurements in imperial units' do
    automobile.urbanity.humanize.should == "75%"
    automobile.weekly_distance_estimate.humanize.should == "10 miles"
    automobile.weekly_cost_estimate.humanize.should == "$45.00"

    boat.weekly_distance_estimate.humanize.should == "10.8 nautical miles"

    candy.price.humanize.should == "$12.00"
  end
end
