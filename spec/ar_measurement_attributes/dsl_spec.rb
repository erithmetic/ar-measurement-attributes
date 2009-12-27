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
end
