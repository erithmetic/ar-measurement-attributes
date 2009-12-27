module ARMeasurementAttributes
  GEMSPEC = Gem::Specification.new do |s|
    s.platform  =   Gem::Platform::RUBY
    s.name      =   "ar_measurement_attributes"
    s.version   =   "0.1.0"
    s.author    =   "Derek Kastner"
    s.email     =   "dkastner@gmail.com"
    s.summary   =   "Measurement attributes for ActiveRecord objects"
    s.files     =   Dir.glob('lib/**/*.rb') + ['rails/init.rb']
    s.require_path  =   "lib"
    s.test_files = Dir.glob('spec/**/*') + Dir.glob('integration/**/*')
    s.has_rdoc  =   true
    s.add_dependency('conversions')
    s.add_development_dependency('rspec')
  end
end

ARMeasurementAttributes::GEMSPEC
