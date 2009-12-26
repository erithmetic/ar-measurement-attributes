require File.join(File.dirname(__FILE__),'..','spec_helper')

describe ARMeasurementAttributes::Core do
  before(:all) do
    length_options = { :internal => :kilometres, :external => :miles }
    ARMeasurementAttributes::DEFAULT_MEASUREMENTS[:length] = length_options
  end

  describe :output do
    before(:each) do
      @value = ARMeasurementAttributes::Value.new(:length, 15, {})
    end
    it 'should return the raw data by default' do
      @value.output.should == 15
    end
    it 'should return the pretty-formatted data if the :pretty option is given' do
      @value.options = :pretty
      @value.output.should == '15mi'
    end
    it 'should return the pretty-formatted data if the options param is true' do
      @value.options = true
      @value.output.should == '15mi'
    end
    it 'should return the pretty-formatted data if the options param is a hash containing :pretty => true' do
      @value.options = { :params => true }
      @value.output.should == '15mi'
    end
  end
end
