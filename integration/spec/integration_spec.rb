require File.join(File.dirname(__FILE__),'spec_helper')

describe 'initialization' do
  it 'should extend ActiveRecord::Base with ARMeasurementAttributes::ClassMethods' do
    ActiveRecord::Base.should be_a_kind_of(ARMeasurementAttributes::ClassMethods)
  end
end

describe ARMeasurementAttributes do
  class Automobile < ActiveRecord::Base
    percentage :urbanity, :precision => 0
    length :weekly_distance_estimate
    cost :weekly_cost_estimate
  end

  class Boat < ActiveRecord::Base
    length :weekly_distance_estimate, :precision => 2
    mass :displacement, :external => :tons, :precision => 0
  end

  class Candy < ActiveRecord::Base
    price :price, :precision => 2 # override default precision
  end

  def automobile
    @automobile ||= Automobile.create(
      :urbanity => 0.74999999999999999999999,
      :weekly_distance_estimate => 16.0,
      :weekly_cost_estimate => 45.00)
  end
  def boat
    @boat ||= Boat.create(:weekly_distance_estimate => 20, :displacement => 8937)
  end
  def candy
    @candy ||= Candy.create(:price => 12)
  end

  it 'should save measurements in metric units' do
    automobile.urbanity.should be_close(0.74999999999999999999999, 0.001)
    automobile.weekly_distance_estimate.should == 16.0
    automobile.weekly_cost_estimate.should == 45.0

    boat.weekly_distance_estimate.should == 20

    candy.price.should == 12.00
  end
  it 'should display measurements in imperial units' do
    automobile.pretty_urbanity(:precision => 0).should == "75%"
    automobile.urbanity = 0.75234
    automobile.pretty_urbanity(:precision => 3).should == "75.234%"
    automobile.pretty_weekly_distance_estimate.should == "9.94193907579734mi"
    automobile.pretty_weekly_cost_estimate.should == "$45"

    automobile.weekly_cost_estimate = 45.87
    automobile.pretty_weekly_cost_estimate.should == "$45.87"

    boat.pretty_weekly_distance_estimate.should == "12.43mi"
    boat.pretty_displacement.should == "10 tons"

    candy.pretty_price.should == "$12.00"
  end
  it 'should correctly handle nil values' do
    automobile.urbanity = nil
    automobile.pretty_urbanity.should be_nil
  end
end
