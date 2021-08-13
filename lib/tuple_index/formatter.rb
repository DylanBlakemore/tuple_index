module TupleIndex
  class Formatter

    attr_reader :tuples, :indexes, :fields, :limit

    def initialize(tuples, indexes, fields, limit=10)
      @tuples = tuples
      @indexes = indexes
      @fields = fields
      @limit = limit
    end

    def table
      max_widths = all_columns.map { |r| r.max_by { |s| s.to_s.size }.to_s.size }
      result = "\n"
      all_columns.transpose.each do |row|
        result << (::Array.new(all_columns.length) { |c| "%#{max_widths[c] + 2}s" }.join(" ") % row)
        result << "\n"
      end
      result
    end

    private

    def data
      tuples.first(limit) || []
    end

    def all_columns
      indexes_columns + field_columns
    end

    def indexes_columns
      indexes.take(limit).map do |col|
        data.map do |datum|
          truncate_string(datum[col])
        end.take(limit).unshift(col).unshift("")
      end
    end

    def field_columns
      fields.take(limit).map do |col|
        data.map do |datum|
          truncate_string(datum[col])
        end.take(limit).unshift("").unshift(col)
      end
    end

    def truncate_string(value)
      value.to_s.truncate(40)
    end

  end
end
