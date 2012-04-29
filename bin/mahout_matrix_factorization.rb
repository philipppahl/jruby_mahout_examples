require File.expand_path('../../config/environment',  __FILE__)

WORKDIR = '/tmp/mf'
RATINGS = 'matrix_factorization_and_dimension_reduction/movielens/ratings.csv'

task :default => [:parallel_als, :transpose_user, :matrixmult]

# run the matrix factorization
task :parallel_als do
  mf = MahoutScript.new 'parallelALS'
  mf.options = {
    :input => RATINGS,
    :output => "#{WORKDIR}/parallel_als",
    :tempDir => "#{WORKDIR}/tmp/parallel_als",
    :numFeatures => 5,
    :numIterations => 5,
    :lambda => 0.05
  }
  mf.run :local
end

# dump the user vectors on the screen
task :vectordump_user do
  vd = MahoutScript.new 'vectordump'
  vd.options = {
    :seqFile => "#{WORKDIR}/parallel_als/U/part*"
  }
  vd.run :local
end

# transpose the user matrix in order to generate the rating matrix in
# the next task
task :transpose_user do
  temp_dir = FileUtilsHelper::mkdir "#{WORKDIR}/tmp/transpose_user" 
  tu = MahoutScript.new 'transpose'
  tu.options = {
    :input   => "#{WORKDIR}/parallel_als/U/part*",
    :tempDir => temp_dir,
    :numCols => 5,
    :numRows => 6040
  }
  tu.run :local
end

task :transpose_item do
  temp_dir = FileUtilsHelper::mkdir "#{WORKDIR}/tmp/transpose_user" 
  ti = MahoutScript.new 'transpose'
  ti.options = {
    :input   => "#{WORKDIR}/parallel_als/M/part*",
    :tempDir => temp_dir,
    :numCols => 5,
    :numRows => 3704
  }
  ti.run :local
end

task :vectordump_user_t do
  vd = MahoutScript.new 'vectordump'
  vd.options = {
    :seqFile => "/tmp/mf/parallel_als/U/transpose-96/part-00000"
  }
  vd.run :local
end

task :vectordump_items do
  vd = MahoutScript.new 'vectordump'
  vd.options = {
    :seqFile => "#{WORKDIR}/parallel_als/M/part*"
  }
  vd.run :local
end

task :vectordump_items_t do
  vd = MahoutScript.new 'vectordump'
  vd.options = {
    :seqFile => "/tmp/mf/parallel_als/M/transpose-23/part-00000"
  }
  vd.run :local
end



task :matrixmult do
  temp_dir = FileUtilsHelper::mkdir "#{WORKDIR}/tmp/matrixmult"
  mm = MahoutScript.new 'matrixmult'
  mm.options = {
    :inputPathA => "#{WORKDIR}/parallel_als/U/part*",
    :inputPathB => "#{WORKDIR}/parallel_als/M/transpose*/part*",
    :tempDir    => temp_dir,
    # :numRowsA    => 5,
    # :numColsA   => 6040,
    # :numRowsB   => 5,
    # :numColsB   => 3704 
    numRows => 6040,
    numCols => 3704
  }
  mm.run :local
end

task :matrixdump do
  md = MahoutScript.new 'vectordump'
  md.options = {
    :seqFile =>  "/tmp/mf/tmp/productWith-203/part-00000"
  }
  md.run :local
end