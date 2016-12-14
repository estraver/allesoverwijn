module Recollect::Collection::Array
  module Array
    extend Forwardable
    def_delegators :@collection, :size, :first, :last, :each_with_index

    def collect
      new_collection = []
      collection.each do | elem |
        new_collection << yield(elem)
      end
      new_collection
    end

    # def each_with_index
    #
    # end

    alias :map :collect

    # def first
    #   collection.first
    # end
    #
    # def last
    #   collection.last
    # end
    #
    # def size
    #   collection.size
    # end
  end
  include Array

end