
class ScatterPlot
  
  def initialize data
    @width  = 400
    @height = 400
    @vis    = pv.Panel.new().width(@width).height(@height).bottom(20).left(20).right(10).top(5);
    @data   = fill_data_struct(data)
    setup
  end
  
  def setup
    @width = 400
    @height = 400
    
    x = pv.Scale.linear(0, 99).range(0, @width)
    y = pv.Scale.linear(0, 99).range(0, @height)
    
    c = pv.Scale.log(1, 100).range("orange", "brown")
    
    # Y-axis and ticks. 
    @vis.add(pv.Rule)
        .data(y.ticks())
        .bottom(y)
        .strokeStyle(lambda {|d| d!=0 ? "#eee" : "#000"})
        .anchor("left").add(pv.Label)
        .visible(lambda {|d|  d > 0 and d < 100})
        .text(y.tick_format)
    
    # X-axis and ticks. 
    @vis.add(pv.Rule)
        .data(x.ticks())
        .left(x)
        .stroke_style(lambda {|d| d!=0 ? "#eee" : "#000"})
      .anchor("bottom").add(pv.Label)
      .visible(lambda {|d|  d > 0 and d < 100})
      .text(x.tick_format);
    
    #/* The dot plot! */
    @vis.add(pv.Panel)
        .data(@data)
      .add(pv.Dot)
      .stroke_style(lambda {|d| c.scale(d.z)})
      .fill_style(lambda {|d| c.scale(d.z).alpha(0.2)})
      .shape_size(lambda {|d| d.z})
      .title(lambda {|d| "%0.1f troet" % d.z})
  end

        # .bottom(lambda {|d| y.scale(d.y)})
        # .left(lambda {|d| x.scale(d.x)})
  
  def fill_data_struct data
    data.map{|coordinate|
      OpenStruct.new({x: coordinate[:x], y: coordinate[:y], z: 10})
    }
  end
  
  def draw filename
    @vis.render
    File.open(filename, 'w'){|file|
      file.puts @vis.to_svg 
    }
  end
  
end