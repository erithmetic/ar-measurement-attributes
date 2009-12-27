require 'ar_measurement_attributes'

ActiveRecord::Base.send(:extend, ARMeasurementAttributes::ClassMethods)
