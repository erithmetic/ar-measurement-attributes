require File.join(File.dirname(__FILE__),'..','spec_helper')

describe ARMeasurementAttributes::Core do
  class CoreHarness
    def read_attribute(*args)
      15
    end
    def write_attribute(*args); args.first; end
  end

  before(:all) do
    length_options = { :internal => :kilometres, :external => :miles }
    ARMeasurementAttributes.default_measurements[:length] = length_options
  end

  before(:each) do
    @instance = CoreHarness.new
  end

  describe :define_getter do
    before(:all) do
      ARMeasurementAttributes::Core.define_getter(CoreHarness, :length, :entfernung, :precision => 1)
      @instance = CoreHarness.new
    end
    it 'should define a method on the target class with the given name' do
      @instance.should respond_to(:pretty_entfernung)
    end
    it 'should delegate the call to :read_measurement' do
      ARMeasurementAttributes::Core.should_receive(:read_measurement).
        with(@instance, :length, :entfernung, {:precision => 1}, {}) 
      @instance.pretty_entfernung
    end
    it 'should send any runtime options to :read_measurement' do
      ARMeasurementAttributes::Core.should_receive(:read_measurement).
        with(@instance, :length, :entfernung, {:precision => 1}, {:entwicklung => :ausblick_des_flusses})

      @instance.pretty_entfernung(:entwicklung => :ausblick_des_flusses)
    end
  end

  describe :read_measurement do
    it "should create a Value object with stored value and merged options" do
      ARMeasurementAttributes::Core.should_receive(:compile_options).and_return({:hi => :fi})
      ARMeasurementAttributes::Value.should_receive(:new).with(:coolness, 15, :hi => :fi).
        and_return(mock(Object, :output => 3))

      ARMeasurementAttributes::Core.read_measurement(@instance, :coolness, :i_phonity)
    end
  end

  describe :compile_options do
    before(:all) do
      length_options = { :internal => :kilometres, :external => :miles }
      ARMeasurementAttributes.default_measurements[:length] = length_options
    end
    it "should return the measurement's default options if no other options are defined" do
      ARMeasurementAttributes::Core.compile_options(:length, {}, {}).
        should == { :internal => :kilometres, :external => :miles }
    end
    it 'should overwrite default options with dsl-defined options' do
      ARMeasurementAttributes::Core.compile_options(:length, { :external => :furlongs, :precision => 2 }, {}).
        should include(:internal => :kilometres, :external => :furlongs, :precision => 2)
    end
    it 'should overwrite default options and dsl-defined options with runtime options' do
      ARMeasurementAttributes::Core.compile_options(
        :length, 
        { :external => :furlongs, :precision => 2 }, 
        { :internal => :meters, :precision => 3, :capitalize => true }).
        should include(:internal => :meters, :external => :furlongs, :precision => 3, :capitalize => true)
    end
  end
end
