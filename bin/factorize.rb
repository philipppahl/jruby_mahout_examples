require File.expand_path('../../config/environment',  __FILE__)

# factorize the known ratings
netflix_ratings = AlsFactorizer.new( ARGV[0] || 'ratings.csv' )

# factorize the ratings with 5 features, regularization of 0.04 and 1 iteration
netflix_ratings.factorize(50, 0.5, 20)

# singular value decomposition

svd = SingularValueDecomposition.new(netflix_ratings.rating_matrix)
p svd.singular_values.to_a
puts "Matrix rank: #{svd.rank}"
