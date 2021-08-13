module TupleIndex
  module Slicer

    def self.slice_indexes(tuples, indexes, slice)
      drop = single_keys(slice)
      sliced_tuples = tuples.map do |tuple|
        tuple.except(*drop) if tuple_matches?(tuple, slice)
      end.compact

      [sliced_tuples, indexes - drop]
    end

    def self.slice_fields(tuples, indexes, fields)
      keys = indexes + fields
      sliced_tuples = tuples.map do |tuple|
        tuple.slice(*keys)
      end
      [sliced_tuples, indexes]
    end

    def self.slice_field(tuples, indexes, field)
      slice_fields(tuples, indexes, [field])
    end

    private

    def self.single_keys(slice)
      slice.keys.reject { |k| slice[k].is_a?(Array) }.map(&:to_s)
    end

    def self.tuple_matches?(tuple, slice)
      slice.all? do |k, v|
        if v.is_a?(Array)
          v.include?(tuple[k.to_s])
        else
          tuple[k.to_s] == v
        end
      end
    end
    
  end
end
