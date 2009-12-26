module ARMeasurementAttributes
  class Value
    attr_accessor :measurement, :internal_value, :options

    def initialize(measurement, internal_value, options)
      self.measurement = measurement
      self.internal_value = internalvalue
      self.options = options
    end
    
    def convert_measurement(measurement, value, options)
    end

    def format_measurement(value, options)
    end

    def label_measurement(measurement, value, options)
    end

    def output
      if runtime_options === true || runtime_options[:pretty]
        to_s
      else
        internal_value
      end
    end

    def to_s
      converted_value = convert_measurement(measurement, stored_value, options)
      formatted_value = format_measurement(converted_value, options)
      labeled_value = label_measurement(measurement, formatted_value, options)
    end
  end
end
