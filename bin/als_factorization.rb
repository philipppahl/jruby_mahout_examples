require File.expand_path('../../config/environment',  __FILE__)

# java_import 'org.apache.mahout.*'
java_import 'org.apache.mahout.cf.taste.impl.model.file.FileDataModel'
java_import 'org.apache.mahout.cf.taste.impl.recommender.svd.ALSWRFactorizer'
java_import 'org.apache.mahout.common.iterator.sequencefile.SequenceFileIterator'

task :default => [:read_rating]

RATINGS = 'matrix_factorization_and_dimension_reduction/movielens/ratings.csv'

task :read_rating do
  # FileDataModel.new(File.new(RATINGS.to_s))
  file = java.io.File.new(RATINGS.to_s)
  data = FileDataModel.new(file)
  mf = ALSWRFactorizer.new(data, 20, 0.01, 5)
  result = mf.factorize
  p result.getUserFeatures(677)[0]
end

task :read_clustered_points do
  path = org.apache.hadoop.fs.Path.new('/tmp/clusteredPoints/part-m-00000')
  conf = Configuration.new
  sf = SequenceFileIterator.new(path, true, conf)
  cp = []
  while item = sf.compute_next
    cp << item.get_first.get
  end
  
  path = org.apache.hadoop.fs.Path.new('/tmp/matrix_factorization/M/part-r-00000')
  sf = SequenceFileIterator.new(path, true, conf)
  product_ids = []
  while item = sf.compute_next
    product_ids << item.get_first.get
  end
  
  collected = cp.zip product_ids
  p collected
end

task :read_products do
  
end
