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
    @rating_matrix = rating(result)
  end
  
  # generates the rating matrix from mahout factorization object
  def rating factorization
    num_items = factorization.num_items
    num_users = factorization.num_users


    feature_dim = factorization.getItemFeatures(factorization.get_item_id_mappings.iterator.next.get_key.long_value).length

    vektor = factorization.getItemFeatures(factorization.get_item_id_mappings.iterator.next.get_key.long_value)

    item_matrix = factorization.get_item_id_mappings.iterator.inject([]) do |item_matrix, item_map| 
      item_row = item_map.get_value
      item_vector = factorization.getItemFeatures(item_map.get_key.long_value).to_a
      item_matrix << item_vector
      item_matrix
    end

    user_matrix = factorization.get_user_id_mappings.iterator.inject([]) do |user_matrix, user_map| 
      user_row = user_map.get_value
      user_matrix << factorization.getUserFeatures(user_map.get_key.long_value).to_a
      user_matrix
    end

    user_matrix = Matrix.rows(user_matrix)
    item_matrix = Matrix.rows(item_matrix)
    
    rating_matrix = item_matrix * user_matrix.transpose
    

    dense_matrix = DenseMatrix.new(num_users, num_items)

    rating_matrix.each_with_index{|num, row, col|
      dense_matrix.set_quick(col, row, num)       
    }

    dense_matrix

#    factorization.get_item_id_mappings.iterator.each do |item_map| 
#      item_row = item_map.get_value
#      item_matrix = Matrix[factorization.getItemFeatures(item_map.get_key.long_value).to_a]
#      factorization.get_user_id_mappings.iterator.each do |user_map| 
#        user_row = user_map.get_value
#        user_matrix = Matrix[factorization.getUserFeatures(user_map.get_key.long_value).to_a]
#        rating = item_matrix*user_matrix.transpose
#        rating_matrix.set_quick(user_row,item_row,rating[0,0])
#      end
#    end

   
    #TODO: multiply the vectors and put it into the matrix    
  end
  
  
end
