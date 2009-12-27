module ARMeasurementAttributes
  # Methods that handle functionality more directly related 
  # to the attributes on the ActiveRecord object
  class Core
    class << self
      # Dynamically creates a getter for a named measurement (see ARMeasurementAttributes::DSL#create_attribute)
      def define_getter(target_klass, measurement, name, defined_options = {})
        target_klass.send(:define_method, "pretty_#{name}") do |*args|
          runtime_options = args.first || {}
          ARMeasurementAttributes::Core.
            read_measurement(self, measurement, name, defined_options, runtime_options)
        end
      end

      # Reads a measurement attribute from the ActiveRecord object and formatted according to 
      # options
      def read_measurement(ar_object, measurement, name, dsl_options = {}, runtime_options = {})
        options = compile_options(measurement, dsl_options, runtime_options)
        stored_value = ar_object.read_attribute(name)
        value = ARMeasurementAttributes::Value.new(measurement, stored_value, options)
        value.to_s
      end

      # Merges default measurement options with DSL-specified options and runtime options
      def compile_options(measurement, dsl_options = {}, runtime_options = {})
        options = ARMeasurementAttributes.measurement_options_for(measurement)
        options.merge!(dsl_options)
        options.merge!(runtime_options)
        options
      end
    end
  end
end
