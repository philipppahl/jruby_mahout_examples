class MahoutScript
  
  attr_accessor :program_name, :options
  
  def initialize program_name
    @program_name = program_name
  end
  
  def mahout_args
    @options.map{|opt,val| "--#{opt} #{val}"}.join(' ')
  end
  
  def local_cmd
    "export MAHOUT_LOCAL=true;#{cmd}"
  end

  def cmd
    p "mahout #{@program_name} #{mahout_args}"
    "mahout #{@program_name} #{mahout_args}"
  end

  
  def run mode
    mode == :local ? exec("#{local_cmd}") : exec("#{cmd}")
  end
end