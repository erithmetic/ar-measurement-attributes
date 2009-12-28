# Main module for ARMeasurementAttributes gem. See README
module ARMeasurementAttributes
  # The map of measurement types and the default internal/external 
  # representations
  # 
  # You can add your own type of measurement to the ActiveRecord DSL:
  #  ARMeasurementAttributes.default_measurements[:awesomeness] = { :internal => :quintessence, :external => :charisma }
  #
  # Then in your ActiveRecord definition:
  #  class Computer < ActiveRecord::Base
  #    awesomeness :dudicality
  #  end
  def self.default_measurements
    return @@default_measurements if defined?(@@default_measurements)
    @@default_measurements = {
      :area                 =>  { :internal => :square_metres,         :external => :square_feet },
      :biomass              =>  { :internal => :joules,                :external => :cords },
      :cost                 =>  { :internal => :dollars,               :external => :dollars, 
                                  :precision => 2, :hide_zeros_for_whole_numbers => true },           # according to tradition should be cents
      :length               =>  { :internal => :kilometres,            :external => :miles },             # according to SI should be in metres
      :length_per_volume    =>  { :internal => :kilometres_per_litre,  :external => :miles_per_gallon },
      :mass                 =>  { :internal => :kilograms,             :external => :pounds },
      :electrical_energy    =>  { :internal => :kilowatt_hours,        :external => :kilowatt_hours },
      :speed                =>  { :internal => :kilometres_per_hour,   :external => :miles_per_hour },
      :time                 =>  { :internal => :hours,                 :external => :hours },             # according to SI should be seconds
      :volume               =>  { :internal => :litres,                :external => :gallons },
      :percentage           =>  { :internal => :percentage,            :external => :percentage, :precision => 0 },
    }
  end
  def self.default_measurements=(val)
    @@default_measurements = val
  end

  def self.add_measurement(name, options)
    self.default_measurements[name] = options
    ARMeasurementAttributes::DSL.add_activerecord_dsl_method(name)
  end

  # The map of measurement units and the desired labels for those units.
  # Add a new definition simply by ARMeasurementAttributes.labels[:my_unit] = 'mu'
  def self.labels
    return @@labels if defined?(@@labels)
    @@labels = {
      :cords => ' cords',
      :cubic_feet => 'ft<sup>3</sup>',
      :cubic_metres => 'm<sup>3</sup>',
      :dollars => { :text => '$', :prefix => true },
      :gallons => 'gal',
      :grams => 'g',
      :joules => 'J',
      :kilometres => 'km',
      :kilometres_per_litre => 'km/l',
      :kilowatt_hours => 'kwh',
      :kilometres_per_hour => 'km/h',
      :litres => 'l',
      :hours => 'h',
      :miles => 'mi',
      :miles_per_gallon => 'mpg',
      :miles_per_hour => 'mph',
      :percentage => '%',
      :pounds => 'lbs',
      :short_tons => ' short tons',
      :square_meters => 'm<sup>2</sup>',
      :square_feet => 'ft<sup>2</sup>',
      :tons => ' tons',
    }
  end

  # Add a new unit label definition by ARMeasurementAttributes.labels[:my_unit] = 'mu'
  def self.labels=(val)
    @@labels = val
  end

  # Used internally by DSL to retrieve default measurement options
  def self.measurement_options_for(measurement)
    default_measurements[measurement].dup || {}
  end

  # Used internally by DSL to retrieve labels
  def self.label_for(representation)
    representation.nil? ? '' : labels[representation].dup
  end
end

require 'ar_measurement_attributes/value'
require 'ar_measurement_attributes/core'
require 'ar_measurement_attributes/dsl'
require 'ar_measurement_attributes/class_methods'
