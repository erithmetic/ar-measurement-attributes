module ARMeasurementAttributes
  # Class methods that are inserted into ActiveRecord::Base.  
  # DSL Methods are automagically created for each measurement 
  # type defined in ARMeasurementAttributes.default_measurements.
  # The methods defined here are simply placeholders for 
  # documentation.
  # To customize the types of measurements that can be defined,
  # see ARMeasurementAttributes::default_measurements
  module ClassMethods
    def area(name, custom_options = {}); end
    def biomass(name, custom_options = {}); end
    def cost(name, custom_options = {}); end
    def electrical_energy(name, custom_options = {}); end
    def length(name, custom_options = {}); end
    def length_per_volume(name, custom_options = {}); end
    def mass(name, custom_options = {}); end
    def percentage(name, custom_options = {}); end
    def price(name, custom_options = {}); end
    def speed(name, custom_options = {}); end
    def time(name, custom_options = {}); end
    def volume(name, custom_options = {}); end
  end
end

ARMeasurementAttributes.default_measurements.keys.each do |measurement|
  ARMeasurementAttributes::DSL.add_class_method(measurement)
end
