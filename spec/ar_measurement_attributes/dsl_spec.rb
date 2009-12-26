require File.join(File.dirname(__FILE__),'..','spec_helper')

class TestHarness
  def read_attribute(name); end
  def write_attribute(name); end
end

describe ARMeasurementAttributes::DSL do
  describe :create_attribute do
    before(:all) do
      ARMeasurementAttributes::DSL.create_attribute(TestHarness, :length, :distance)
      @instance = TestHarness.new
    end
    it 'should define a getter' do
      @instance.should respond_to(:distance)
    end
    it 'should define a setter' do
      @instance.should respond_to(:distance=)
    end
  end

  describe :define_getter do
    before(:all) do
      ARMeasurementAttributes::DSL.define_getter(TestHarness, :length, :entfernung, :precision => 1)
      @instance = TestHarness.new
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
      ARMeasurementAttributes::DSL.define_setter(TestHarness, :length, :longitud)
      @instance = TestHarness.new
    end
    it 'should define a method on the target class with the given name' do
      @instance.should respond_to(:longitud=)
    end
    it 'should delegate the call to :read_measurement' do
      ARMeasurementAttributes::Core.should_receive(:write_measurement).with(@instance, :longitud, 3)
      @instance.longitud = 3
    end
  end
end
