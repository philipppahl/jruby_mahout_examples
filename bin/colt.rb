require File.expand_path('../../config/env_colt.rb',  __FILE__)

java_import 'hep.aida.ref.Histogram1D' 

Histogram1D.new("Histogram title", 10, 0.0, 1.0)