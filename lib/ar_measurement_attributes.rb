module ARMeasurementAttributes
  DEFAULT_MEASUREMENTS = {
    :area                 =>  { :internal => :square_metres,         :external => :square_feet },
    :biomass              =>  { :internal => :joules,                :external => :cords },
    :cost                 =>  { :internal => :dollars,               :external => :dollars },           # according to tradition should be cents
    :length               =>  { :internal => :kilometres,            :external => :miles },             # according to SI should be in metres
    :length_per_volume    =>  { :internal => :kilometres_per_litre,  :external => :miles_per_gallon },
    :mass                 =>  { :internal => :kilograms,             :external => :pounds },
    :electrical_energy    =>  { :internal => :kilowatt_hours,        :external => :kilowatt_hours },
    :speed                =>  { :internal => :kilometres_per_hour,   :external => :miles_per_hour },
    :time                 =>  { :internal => :hours,                 :external => :hours },             # according to SI should be seconds
    :volume               =>  { :internal => :litres,                :external => :gallons },
    :percentage           =>  { :internal => nil,                    :external => nil },
  }

  LABELS = {
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
    :gallons => 'gal'
  }

  def self.measurement_options_for(measurement)
    DEFAULT_MEASUREMENTS[measurement] || {}
  end

  def self.label_for(representation)
    representation.nil? ? '' : LABELS[representation]
  end
end

require 'ar_measurement_attributes/value'
require 'ar_measurement_attributes/core'
require 'ar_measurement_attributes/dsl'
require 'ar_measurement_attributes/class_methods'
