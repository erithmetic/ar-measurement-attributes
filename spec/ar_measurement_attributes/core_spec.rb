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
      @instance.should respond_to(:entfernung)
    end
    it 'should delegate the call to :read_measurement' do
      ARMeasurementAttributes::Core.should_receive(:read_measurement).
        with(@instance, :length, :entfernung, {:precision => 1}, {}) 
      @instance.entfernung
    end
    it 'should send any runtime options to :read_measurement' do
      ARMeasurementAttributes::Core.should_receive(:read_measurement).
        with(@instance, :length, :entfernung, {:precision => 1}, {:entwicklung => :ausblick_des_flusses})

      @instance.entfernung(:entwicklung => :ausblick_des_flusses)
    end
  end

  describe :define_setter do
    before(:all) do
      ARMeasurementAttributes::Core.define_setter(CoreHarness, :length, :longitud)
      @instance = CoreHarness.new
    end
    it 'should define a method on the target class with the given name' do
      @instance.should respond_to(:longitud=)
    end
    it 'should delegate the call to :read_measurement' do
      ARMeasurementAttributes::Core.should_receive(:write_measurement).with(@instance, :longitud, 3)
      @instance.longitud = 3
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

  describe :write_measurement do
    it 'should proxy :distance= calls to write_distance' do
      @instance.should_receive(:write_attribute).with(:cry_for_survival, 5)

      ARMeasurementAttributes::Core.write_measurement(@instance, :cry_for_survival, 5)
    end
  end

  describe :compile_options do
    before(:all) do
      length_options = { :internal => :kilometres, :external => :miles }
      ARMeasurementAttributes.default_measurements[:length] = length_options
    end
    it 'should set runtime options to :pretty => true if :pretty option is given' do
      ARMeasurementAttributes::Core.compile_options(:length, {}, :pretty).
        should include(:internal => :kilometres, :external => :miles, :pretty => true)
    end
    it 'should return the pretty-formatted data if the options param is true' do
      ARMeasurementAttributes::Core.compile_options(:length, {}, true).
        should include(:internal => :kilometres, :external => :miles, :pretty => true)
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
