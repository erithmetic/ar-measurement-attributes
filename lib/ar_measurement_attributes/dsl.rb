module ARMeasurementAttributes
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
        define_getter(target_klass, measurement, name, options)
        define_setter(target_klass, measurement, name, options)
      end

      # Dynamically creates a getter for a named measurement (see #create_attribute)
      def define_getter(target_klass, measurement, name, defined_options = {})
        target_klass.send(:define_method, name) do |*args|
          runtime_options = args.first || {}
          ARMeasurementAttributes::Core.
            read_measurement(self, measurement, name, defined_options, runtime_options)
        end
      end

      # Dynamically creates a setter for a named measurement (see #create_attribute)
      def define_setter(target_klass, measurement, base_name, default_options = {})
        name = "#{base_name}=".to_sym
        target_klass.send(:define_method, name) do |value|
          ARMeasurementAttributes::Core.
            write_measurement(self, base_name, value)
        end
      end
    end
  end
end
