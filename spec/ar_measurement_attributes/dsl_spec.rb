require File.join(File.dirname(__FILE__),'..','spec_helper')

class TestHarness
  def read_attribute(name); end
  def write_attribute(name); end
end

describe ARMeasurementAttributes::DSL do
  describe :create_attribute do
    it 'should define a getter' do
      ARMeasurementAttributes::Core.should_receive(:define_getter)
      ARMeasurementAttributes::DSL.create_attribute(TestHarness, :length, :distance)
    end
  end
end
