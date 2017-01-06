module Recollect::Collection::Array
  module Array
    extend Forwardable
    def_delegators :@collection, :size, :first, :last, :each_with_index, :empty?

    def collect
      new_collection = []
      collection.each do | elem |
        new_collection << yield(elem)
      end
      new_collection
    end

    alias :map :collect
  end
  include Array

end