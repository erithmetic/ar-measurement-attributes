require File.join(File.dirname(__FILE__),'..','spec_helper')

describe ARMeasurementAttributes::Core do
  before(:all) do
    length_options = { :internal => :kilometres, :external => :miles }
    ARMeasurementAttributes.default_measurements[:length] = length_options
  end
  before(:each) do
    @value = ARMeasurementAttributes::Value.new(:length, 15, {})
  end

  describe :output do
    it 'should return the raw data by default' do
      @value.should_receive(:internal_value)
      @value.output
    end
    it 'should return the string representation if the :pretty option is given' do
      @value.options = :pretty
      @value.should_receive(:to_s)
      @value.output
    end
    it 'should return the string representation if the options param is true' do
      @value.options = true
      @value.should_receive(:to_s)
      @value.output
    end
    it 'should return the string representation if the options param is a hash containing :pretty => true' do
      @value.options = { :pretty => true }
      @value.should_receive(:to_s)
      @value.output
    end
  end

  describe :convert_measurement do
    it 'should convert the internal value from its internal representation into the external representation' do
      @value.internal_value = 18.888883
      @value.convert_measurement.should be_close(11.737, 0.001)
    end
    it 'should not do any conversion if the formats given are nil' do
      @value.options = { :internal => nil, :external => nil }
      @value.internal_value = 18.8
      @value.convert_measurement.should == 18.8
    end
    it 'should include a scale argument to the call to conversion if precision is specified' do
      @value.options[:precision] = 1
      mock_fixnum = mock(Fixnum)
      @value.stub!(:internal_value).and_return(mock_fixnum)
      mock_fixnum.should_receive(:convert).
        with(:kilometres, :miles, { :scale => 1 })

      @value.convert_measurement
    end
    it 'should format the value with a given precision' do
      @value.options = { :precision => 4 }
      @value.internal_value = 19.23232323
      @value.convert_measurement.should == 11.9504
    end
    it 'should convert percentages from a decimal <= 1 to a number <= 100 with a given scale' do
      @value.options = { :precision => 2 }
      @value.measurement = :percentage
      @value.internal_value = 0.76542

      @value.convert_measurement.should == 76.54
    end
    it 'should convert percentages with no scale specified' do
      @value.measurement = :percentage
      @value.internal_value = 0.76542

      @value.convert_measurement.should == 76.542
    end
  end

  describe :label_measurement do
    it 'should add a label to the end of the measurement' do
      @value.label_measurement(23).should == '23mi'
    end
    it 'should prefix a label if the :prefix option is true' do
      @value.options = { :prefix => true }
      @value.label_measurement(23).should == 'mi23'
    end
    it 'should not label the value if the external representation is nil' do
      @value.options = { :external => nil }
      @value.label_measurement(23).should == '23'
    end
  end

  context 'integration' do
    before(:each) do
      @value.options[:precision] = 2
    end
    it 'should return the raw data by default' do
      @value.output.should == 15
    end
    it 'should return the pretty-formatted data if the :pretty option is given' do
      @value.options = :pretty
      @value.output.should == '9.32056788356001mi'
    end
    it 'should return the pretty-formatted data if the options param is true' do
      @value.options = true
      @value.output.should == '9.32056788356001mi'
    end
    it 'should return the pretty-formatted data if the options param is a hash containing :pretty => true' do
      @value.options[:pretty] = true
      @value.output.should == '9.32mi'
    end
  end
end
