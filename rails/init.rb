module ARMeasurementAttributes
  module Rails
    class Initializer
      def self.init
        ActiveRecord::Base.send(:extend, ARMeasurementAttributes::ClassMethods)
      end
    end
  end
end

ARMeasurementAttributes::Rails::Initializer.init
