module TupleIndex
  class Container

    attr_reader :tuples, :indexes

    def initialize(tuples, indexes)
      @tuples = tuples
      @indexes = indexes.map(&:to_s)
    end

    def self.concat(tuple_indexes)
      raise(IndexMismatchError, "Indexes must match for tuple concatenation") unless tuple_indexes.map(&:indexes).uniq.size == 1
      TupleIndex::Container.new(
        tuple_indexes.map(&:tuples).reduce([], :concat),
        tuple_indexes.first.indexes
      )
    end

    def inspect
      TupleIndex::Formatter.new(tuples, indexes, fields).table
    end

    def fields
      @fields ||= keys - indexes
    end

    def [](args)
      sliced_tuples, sliced_indexes = slice(args)
      self.class.new(
        sliced_tuples,
        sliced_indexes
      )
    end

    def size
      @size ||= tuples.size
    end

    def first(n=1)
      self.class.new(
        tuples.first(n),
        indexes
      )
    end

    def members(key)
      raise(ArgumentError, "TupleIndex#members only accepts index keys") unless indexes.include?(key.to_s)
      members_cache[key.to_s] ||= tuples.map { |tuple| tuple[key.to_s] }.compact.uniq
    end

    private

    def members_cache
      @members_cache ||= {}
    end

    def keys
      @keys ||= tuples.flat_map(&:keys).uniq
    end

    def slice(args)
      case args
      when Hash
        TupleIndex::Slicer.slice_indexes(tuples, indexes, args.stringify_keys)
      when String, Symbol
        TupleIndex::Slicer.slice_field(tuples, indexes, args.to_s)
      when Array
        TupleIndex::Slicer.slice_fields(tuples, indexes, args)
      end
    end

  end
end
