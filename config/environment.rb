# lib contains all classes
$: << File.expand_path('../../lib',  __FILE__)
require 'java'

puts File.expand_path('../../lib',  __FILE__)


# mahout
jars = [
  'mahout-core-0.6.jar', 
  'mahout-examples-0.6-job.jar',
  'mahout-core-0.6-job.jar',
  'hadoop-core-0.20.2-cdh3u3.jar',
  'mahout-math-0.6'
  ]
  
jars.map!{|file| "#{File.expand_path('../..', __FILE__)}/lib/java/#{file}"}
jars.each{|jar| require jar}

#include org.apache.mahout.cf.taste.impl.model.file.FileDataModel
#java_import 'org.apache.mahout.*'
java_import 'org.apache.mahout.cf.taste.impl.model.file.FileDataModel'
java_import 'org.apache.mahout.cf.taste.impl.recommender.svd.ALSWRFactorizer'
java_import 'org.apache.mahout.common.iterator.sequencefile.SequenceFileIterator'
java_import 'org.apache.mahout.math.SingularValueDecomposition'

# used by scatter_plot
#require 'scatter_plot'
#require 'rubyvis'
require 'als_factorizer'


