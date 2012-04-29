# lib contains all classes
$: << File.expand_path('../../lib',  __FILE__)

# used by scatter_plot
require 'rubyvis'
require 'scatter_plot'

require 'java'

# mahout
jars = [
  'mahout-core-0.6.jar', 
  'mahout-examples-0.6-job.jar',
  'mahout-core-0.6-job.jar',
  'hadoop-core-0.20.2-cdh3u3.jar'
  ]
  
jars.map!{|file| "#{File.expand_path('../..', __FILE__)}/lib/java/#{file}"}
jars.each{|jar| require jar}
