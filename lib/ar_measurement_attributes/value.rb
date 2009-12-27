require 'active_resource'
require 'conversions'

module ARMeasurementAttributes
  class Value
    attr_accessor :measurement, :internal_value, :options

    def initialize(measurement, internal_value, options)
      self.measurement = measurement
      self.internal_value = internal_value
      self.options = (options || {})
    end

    def options=(val)
      default_options = ARMeasurementAttributes.measurement_options_for(measurement)
      if val === true || val == :pretty
        @options = default_options.merge({ :pretty => true })
      else
        @options = default_options.merge(val)
      end
    end

    def scale
      scale = options[:precision] || options[:scale]
    end
    
    def convert_measurement
      return convert_percentage if measurement == :percentage
      return internal_value if options[:internal].nil? || options[:external].nil?

      args = [options[:internal], options[:external]]
      args << { :scale => scale } if scale
      internal_value.convert(*args)
    end

    def convert_percentage
      percentage = internal_value * 100

      if scale
        ("%.#{scale}f" % percentage).to_f
      else
        percentage
      end
    end

    def label_measurement(value)
      return value.to_s if options[:external].nil?

      label = ARMeasurementAttributes.label_for(options[:external])

      if options[:prefix]
        "#{label}#{value}"
      else
        "#{value}#{label}"
      end
    end

    def output
      if options[:pretty]
        to_s
      else
        internal_value
      end
    end

    def to_s
      converted_value = convert_measurement
      label_measurement(converted_value)
    end
  end
end
