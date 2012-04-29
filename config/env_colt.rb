require File.expand_path('../environment',  __FILE__)

puts "loading the jars"

jars = [
  'colt.jar',
  'concurrent.jar'
  ]
  
jars.map!{|file| "#{File.expand_path('../..', __FILE__)}/lib/java/colt/#{file}"}
jars.each{|jar| require jar}