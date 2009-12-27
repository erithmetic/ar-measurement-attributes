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
      :cost                 =>  { :internal => :dollars,               :external => :dollars, :precision => 2},           # according to tradition should be cents
      :length               =>  { :internal => :kilometres,            :external => :miles },             # according to SI should be in metres
      :length_per_volume    =>  { :internal => :kilometres_per_litre,  :external => :miles_per_gallon },
      :mass                 =>  { :internal => :kilograms,             :external => :pounds },
      :electrical_energy    =>  { :internal => :kilowatt_hours,        :external => :kilowatt_hours },
      :speed                =>  { :internal => :kilometres_per_hour,   :external => :miles_per_hour },
      :time                 =>  { :internal => :hours,                 :external => :hours },             # according to SI should be seconds
      :volume               =>  { :internal => :litres,                :external => :gallons },
      :percentage           =>  { :internal => :percentage,            :external => :percentage, :precision => 0 },
      :price                =>  { :internal => :dollars,               :external => :dollars },
    }
  end
  def self.default_measurements=(val)
    @@default_measurements = val
  end

  # The map of measurement units and the desired labels for those units.
  # Add a new definition simply by ARMeasurementAttributes.labels[:my_unit] = 'mu'
  def self.labels
    return @@labels if defined?(@@labels)
    @@labels = {
      :square_meters => 'm<sup>2</sup>',
      :joules => 'J',
      :squere_feet => 'ft<sup>2</sup>',
      :cords => ' cords',
      :dollars => { :text => '$', :prefix => true },
      :kilometres => 'km',
      :kilometres_per_litre => 'km/l',
      :kilowatt_hours => 'kwh',
      :kilometres_per_hour => 'km/h',
      :litres => 'l',
      :hours => 'h',
      :miles => 'mi',
      :miles_per_hour => 'mph',
      :miles_per_gallon => 'mpg',
      :pounds => 'lbs',
      :gallons => 'gal',
      :percentage => '%'
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
