require File.expand_path('../../config/environment',  __FILE__)

class AlsFactorizer
  
  attr_accessor :rating_matrix
  
  def initialize ratings
    file = java.io.File.new(ratings)
    @data = FileDataModel.new(file)
  end
  
  # factorize the ratings
  # @param
  #   features:   number of features
  #   lambda:     regularization parameter
  #   iterations: number of iterations for the calculation
  def factorize(features, lambda, iterations)
    result = ALSWRFactorizer.new(@data, features, lambda, iterations).factorize
    
    # transform the result into rating matrix
    @rating_matrix = rating_matrix(result)
  end
  
  # generates the rating matrix from mahout factorization object
  def rating_matrix factorization
    p num_users = factorization.num_users
    p num_items = factorization.num_items

    factorization.get_item_id_mappings.each{|mapping| 
      puts factorization.getItemFeatures(mapping.get_key.long_value).to_a << "\n"
    }


    
    #TODO: multiply the vectors and put it into the matrix    
  end
  
  
end
