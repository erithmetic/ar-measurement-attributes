module ARMeasurementAttributes
  # Class for defining DSL class-level methods and translating 
  # defined attributes into getters and setters
  class DSL
    class << self
      # Adds a new type of measurement to the DSL
      def add_class_method(measurement)
        ARMeasurementAttributes::ClassMethods.send(:define_method, measurement) do |name, *args|
          custom_options = args.first || {}
          ARMeasurementAttributes::DSL.create_attribute(self, measurement, name, custom_options)
        end 
      end

      # Dynamically creates getters and setters for a named measurement
      # defined by the user's ActiveRecord definition
      #
      # Example:
      #  class Sauce < ActiveRecord::Base
      #    mass :meat_mass
      #  end
      # Will create a getter and setter for a new #meat_mass attribute
      def create_attribute(target_klass, measurement, name, options = {})
        ARMeasurementAttributes::Core.define_getter(target_klass, measurement, name, options)
        ARMeasurementAttributes::Core.define_setter(target_klass, measurement, name, options)
      end
    end
  end
end
