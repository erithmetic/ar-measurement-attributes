require File.join(File.dirname(__FILE__),'..','spec_helper')

describe ARMeasurementAttributes::Core do
  before(:all) do
    @length_options = { :internal => :kilometres, :external => :miles }
  end
  before(:each) do
    @value = ARMeasurementAttributes::Value.new(:length, 15, @length_options)
  end

  describe :convert_measurement do
    it 'should convert the internal value from its internal representation into the external representation' do
      @value.internal_value = 18.888883
      @value.convert_measurement.should == '11.7370077497415'
    end
    it 'should not do any conversion if the formats given are nil' do
      @value.options = { :internal => nil, :external => nil }
      @value.internal_value = 18.8
      @value.convert_measurement.should == 18.8
    end
    it 'should format the value with a given precision' do
      @value.options[:precision] = 4
      @value.internal_value = 19.23232323
      @value.convert_measurement.should == '11.9504'
    end
    it 'should convert percentages from a decimal <= 1 to a number <= 100 with a given scale' do
      @value.options[:precision] = 2
      @value.measurement = :percentage
      @value.internal_value = 0.76542

      @value.convert_measurement.should == '76.54'
    end
    it 'should convert percentages with no scale specified' do
      @value.options[:precision] = nil
      @value.measurement = :percentage
      @value.internal_value = 0.76542

      @value.convert_measurement.should == '76.542'
    end
  end

  describe :scale_value do
    before(:each) do
      @value.options[:precision] = 2
    end
    it 'should show decimal places if the :hide_zeros_for_whole_numbers option is not set and the number is whole' do
      @value.scale_value(1.0000).to_s.should == '1.00'
    end
    it 'should show no decimal places if the :hide_zeros_for_whole_numbers option is set and the number is whole' do
      @value.options[:hide_zeros_for_whole_numbers] = true
      @value.scale_value(1.0000).to_s.should == '1'
    end
    it 'should show decimal places if the :hide_zeros_for_whole_numbers option is set and the number is not whole' do
      @value.options[:hide_zeros_for_whole_numbers] = true
      @value.scale_value(1.77).to_s.should == '1.77'
    end
  end

  describe :label_measurement do
    it 'should add a label to the end of the measurement' do
      @value.label_measurement('23').should == '23mi'
    end
    it 'should prefix a label if the :prefix option is true' do
      @value.options[:external] = :dollars
      @value.label_measurement('23').should == '$23'
    end
    it 'should not label the value if the external representation is nil' do
      @value.options[:external] = nil
      @value.label_measurement('23').should == '23'
    end
  end

  describe :to_s do
    it 'should return nil if the internal value is nil' do
      @value.internal_value = nil
      @value.to_s.should be_nil
    end
  end

  context 'integration' do
    before(:each) do
      @value.options[:precision] = 2
    end
    it 'should return the pretty-formatted data' do
      @value.options[:pretty] = true
      @value.to_s.should == '9.32mi'
    end
    it 'should format a price with a whole amount of dollars with no decimal places' do
      value = ARMeasurementAttributes::Value.new(:cost, 12.0, 
                                                 :precision => 2, :hide_zeros_for_whole_numbers => true,
                                                 :internal => :dollars, :external => :dollars)
      value.to_s.should == '$12'
    end
  end
end
