require File.expand_path('../../config/environment',  __FILE__)

data = [
  {:x => 20.0, :y => 20.0},
  {:x => 50.0, :y => 20.0}
]

plot = ScatterPlot.new data
plot.draw 'test.svg'
