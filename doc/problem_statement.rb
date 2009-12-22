################################################################################
# TASK
################################################################################
# Write some code (maybe even publish a gem) that makes it easy to store and
# pretty-print real-world measurements in ActiveRecord.

################################################################################
# DETAILS
################################################################################
# It has two primary requirements: first, store stuff in metric; second,
# pretty print stuff in imperial. For example:

class Automobile < ActiveRecord::Base
  # You define the DSL!
  xxxxxxxxxx :urbanity, :is => :percentage
  xxxxxxxxxx :weekly_distance_estimate, :is => :length
  xxxxxxxxxx :weekly_cost_estimate, :is => :cost
end

class Boat < ActiveRecord::Base
  xxxxxxxxxx :weekly_distance_estimate, :is => :length, :external => :nautical_miles # override default external unit
end

class Candy < ActiveRecord::Base
  xxxxxxxxxx :price, :is => :cost, :precision => 2 # override default precision
end

>> automobile.urbanity
=> 0.74999999999999999999999
>> automobile.yyyyyyyyyyy :urbanity # you define the API!
=> "75%"
>> automobile.weekly_distance_estimate
=> 16.09344
>> automobile.yyyyyyyyyyy :weekly_distance_estimate
=> "10 miles"
>> automobile.cost
=> 45.0
>> automobile.yyyyyyyyyyy :cost
=> "$45"

>> boat.weekly_distance_estimate
=> 20
>> boat.yyyyyyyyyyy :weekly_distance_estimate
=> "10.8 nautical miles"

>> candy.price
=> 12.0
>> candy.yyyyyyyyyyy :price
=> "$12.00"

# OK. It's clear that you could do a million things. But at
# brighterplanet.com, we only care about two things. First, everything should
# be stored in metric (when applicable); second, everything should be
# displayed in pretty imperial formats.
#
# Hint:
# xxxxxxxxxx is like :measures in the old code below
# yyyyyyyyyyy is like external_for in the old code below

################################################################################
# ASSUMPTIONS
################################################################################
# 0) It's OK to start from scratch. You can define a new API.
# 1) We're storing things with ActiveRecord. Don't go overboard trying to
#    make your code work with DataMapper/ActiveResource. It's just a first draft.
# 2) Unit conversions are already provided by the gem named "conversions", e.g.,
#    1.5.kilograms.to(:tons) or if you prefer 1.5.convert(:kilograms, :tons)
# 3) There should be some way to tell the model what units to use externally
#    and internally. It's OK to define a new DSL... we don't mind changing up our
#    models too much. Currently it's defined our "characterize" blocks (see
#    :measures => X), but that's a bad place for it... it deserves its own block.
# 4) Stuff like characterize() and :trumps and reveals() are related to our
#    emissions calculations. Shouldn't matter what they do.
# 5) You can ask Seamus three questions for free ;) After that it's $1 in
#    World of Warcraft gold per question.

################################################################################
# OLD CODE IF YOU REALLY WANT TO SEE IT
################################################################################

NAMED_MEASUREMENTS = {
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
}

class Automobile < Emitter
  # [...]
  characterize do |has|
    has.characteristic :make do |make|
      make.reveals :model_year do |model_year|
        model_year.reveals :model, :trumps => :size_class do |model|
          model.reveals :variant, :trumps => :hybridity
        end
      end
    end
    has.characteristic :size_class
    has.characteristic :fuel_type
    has.characteristic :fuel_efficiency, :trumps => [:urbanity, :hybridity], :measures => :length_per_volume
    has.characteristic :urbanity, :measures => :percentage
    has.characteristic :hybridity
    has.characteristic :daily_distance_estimate, :trumps => [:weekly_distance_estimate, :annual_distance_estimate, :daily_duration], :measures => :length
    has.characteristic :daily_duration, :trumps => [:annual_distance_estimate, :weekly_distance_estimate, :daily_distance_estimate], :measures => :time
    has.characteristic :weekly_distance_estimate, :trumps => [:annual_distance_estimate, :daily_distance_estimate, :daily_duration], :measures => :length
    # [...]
  end
  # [...]
end

class Emitter < ActiveRecord::Base
  self.abstract_class = true
  # attr_accessor :characteristics is a hash of values like {:weekly_distance_estimate => 10.5}
  # attr_accessor :commitee_reports (ditto)
  def external_for(name, options = {})
    if options.has_key?(:value)
      value = options[:value]
    elsif characteristics.has_key?(name)
      value = characteristics[name]
    elsif committee_reports.has_key?(name)
      value = committee_reports[name]
    else
      return ''
    end
    options[:show_unit] = true unless options.has_key?(:show_unit)
    adjective = options[:adjective] === true
    external = value
    measures = measures_for(name)
    m_o = measurement_options_for(name)
    case value
    when Numeric
      if measures == :percentage
        external *= 100.0
      else
        external = external.convert(m_o[:internal], m_o[:external]) if m_o.has_key?(:internal) and m_o.has_key?(:external)
      end
      if measures == :percentage
        external = external.round
      elsif measures == :cost
        external = '%0.2f' % external
        external.gsub!('.00', '')
      elsif !external.is_a?(Integer)
        if p = precision_for(name)
          external = (p == 0) ? external.round : external.round_with_precision(p)
        else
          external = external.adaptive_round
        end
      end
      if options[:show_unit]
        external = "#{external}%" if measures == :percentage
        external = "$#{external}" if measures == :cost
        if m_o.has_key?(:external) and measures != :cost
          unit = m_o[:external].to_s.humanize.downcase
          unit = unit.singularize if adjective
        else
          unit = nil
        end
        external = [ external, unit ].compact.join(' ')
      end
    when ActiveRecord::Base
      external = external.name.andand.titleize
    when Date, Time
      if name.to_s.starts_with?('time')
        external = external.strftime('%I %p').gsub /\A0/, ''
      else
        external = external.to_formatted_s :archive
      end
    when TrueClass
      external = 'Yes'
    when FalseClass
      external = 'No'
    when Hash
      if value.values.all? { |v| (0..1).include? v }
        multiplier = 100
        suffix = '%'
        remove = '_share'
      else
        multiplier = 1
        suffix = ''
        remove = 'foobar'
      end
      external = value.collect { |v| "#{(v[1] * multiplier).round}#{suffix} #{v[0].to_s.gsub(remove, '').humanize.downcase}"}.join(', ')
    else
      raise "#{value.inspect} was a #{value.class}"
    end
    external
  end

  %w{ measures measurement_options precision requires }.each do |method|
    eval %{
      def #{method}_for(c); self.class.characterization.characteristics[c].#{method}; end
    }
  end
  def range_for(c)
    range = self.class.characterization.characteristics[c].range
    if range.is_a? Proc
      range = range.call self
    end
    range
  end
  def unit_for(c); measurement_options_for(c)[:internal]; end
  def external_unit_for(c); measurement_options_for(c)[:external]; end
  def external_accessor_for(c); external_unit_for(c) ? "#{c}_in_#{external_unit_for(c)}" : c; end
  def external_range_for(c)
    range = range_for(c)
    if unit_for(c) and external_unit_for(c)
      first = range.first.convert(unit_for(c), external_unit_for(c))
      last = range.last.convert(unit_for(c), external_unit_for(c))
      range = first..last
    end
    range
  end
end

