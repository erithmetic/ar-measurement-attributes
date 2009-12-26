module ARMeasurementAttributes
  class Core
    class << self
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
