class FileUtilsHelper
  def self.mkdir dir
    FileUtils.mkdir(dir) unless File.exists?(dir)
    dir
  end
end