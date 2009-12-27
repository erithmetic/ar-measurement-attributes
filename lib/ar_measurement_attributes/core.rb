module ARMeasurementAttributes
  # Methods that handle functionality more directly related 
  # to the attributes on the ActiveRecord object
  class Core
    class << self
      # Dynamically creates a getter for a named measurement (see ARMeasurementAttributes::DSL#create_attribute)
      def define_getter(target_klass, measurement, name, defined_options = {})
        target_klass.send(:define_method, name) do |*args|
          runtime_options = args.first || {}
          ARMeasurementAttributes::Core.
            read_measurement(self, measurement, name, defined_options, runtime_options)
        end
      end

      # Dynamically creates a setter for a named measurement (see ARMeasurementAttributes::DSL#create_attribute)
      def define_setter(target_klass, measurement, base_name, default_options = {})
        name = "#{base_name}=".to_sym
        target_klass.send(:define_method, name) do |value|
          ARMeasurementAttributes::Core.
            write_measurement(self, base_name, value)
        end
      end

      def read_measurement(ar_object, measurement, name, dsl_options = {}, runtime_options = {})
        options = compile_options(measurement, dsl_options, runtime_options)
        stored_value = ar_object.read_attribute(name)
        value = ARMeasurementAttributes::Value.new(measurement, stored_value, options)
        value.output
      end

      def write_measurement(ar_object, name, value)
        ar_object.write_attribute(name, value)
      end

      def compile_options(measurement, dsl_options = {}, runtime_options = {})
        options = ARMeasurementAttributes.measurement_options_for(measurement)
        options.merge!(dsl_options)
        options.merge!(runtime_options)
        options
      end
    end
  end
end
