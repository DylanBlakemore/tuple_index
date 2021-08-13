# frozen_string_literal: true
require "active_support/core_ext/hash"
require "active_support/core_ext/string"

require_relative "tuple_index/version"
require_relative "tuple_index/slicer"
require_relative "tuple_index/formatter"
require_relative "tuple_index/container"

module TupleIndex
  class Error < StandardError; end
  class IndexMismatchError < StandardError; end

  def self.new(tuples, indexes)
    TupleIndex::Container.new(tuples, indexes)
  end

end
