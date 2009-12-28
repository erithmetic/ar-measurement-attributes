require 'rubygems'
require 'rake/gempackagetask'
require 'spec'
require 'spec/rake/spectask'

eval(File.read(File.join(File.dirname(__FILE__),'ar_measurement_attributes.gemspec')))

Rake::GemPackageTask.new(ARMeasurementAttributes::GEMSPEC) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
 
Spec::Rake::SpecTask.new do |t|
  t.warning = false
  unless ENV['NO_RCOV']
    t.spec_files = FileList['spec/**/*.rb']
  end
end

