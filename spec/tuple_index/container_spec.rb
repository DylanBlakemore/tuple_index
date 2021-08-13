require "spec_helper"

RSpec.describe TupleIndex::Container do

  subject { described_class.new(tuples, indexes) }

  let(:tuples) do
    [
      { "sentence" => 0, "language" => 10, "word_1" => "hello", "word_2" => "world" },
      { "sentence" => 0, "language" => 11, "word_1" => "bonjour", "word_2" => "monde" },
      { "sentence" => 0, "language" => 12, "word_1" => "hallo", "word_2" => "welt"},
      { "sentence" => 1, "language" => 10, "word_1" => "goodbye", "word_2" => "sweet", "word_3" => "prince" },
      { "sentence" => 1, "language" => 11, "word_1" => "au revoir", "word_2" => "doux", "word_3" => "prince" },
      { "sentence" => 1, "language" => 12, "word_1" => "auf wiedersehen", "word_2" => "süßer", "word_3" => "prinz" }
    ]
  end

  let(:indexes) do
    ["sentence", "language"]
  end

  describe ".concat" do
    let(:tuples_1) do
      [
        { "sentence" => 0, "language" => 10, "word_1" => "hello", "word_2" => "world" },
        { "sentence" => 0, "language" => 11, "word_1" => "bonjour", "word_2" => "monde" },
        { "sentence" => 0, "language" => 12, "word_1" => "hallo", "word_2" => "welt"}
      ]
    end

    let(:tuples_2) do
      [
        { "sentence" => 1, "language" => 10, "word_1" => "goodbye", "word_2" => "sweet", "word_3" => "prince" },
        { "sentence" => 1, "language" => 11, "word_1" => "au revoir", "word_2" => "doux", "word_3" => "prince" },
        { "sentence" => 1, "language" => 12, "word_1" => "auf wiedersehen", "word_2" => "süßer", "word_3" => "prinz" }
      ]
    end

    let(:concatenation) do
      TupleIndex::Container.concat([
        TupleIndex::Container.new(tuples_1, indexes),
        TupleIndex::Container.new(tuples_2, indexes)
      ])
    end

    it "concatenates the tuples" do
      expect(concatenation.tuples).to eq(tuples)
    end

    context "when there is an index mismatch" do
      let(:concatenation) do
        TupleIndex::Container.concat([
          TupleIndex::Container.new(tuples_1, indexes),
          TupleIndex::Container.new(tuples_2, ["sentence"])
        ])
      end

      it "raises an appropriate error" do
        expect { concatenation }.to raise_error(TupleIndex::IndexMismatchError, "Indexes must match for tuple concatenation")
      end
    end
  end

  describe "#inspect" do
    it "formats the table correctly" do
      expect(subject.inspect).to eq("\n                                 word_1   word_2   word_3\n  sentence   language                                    \n         0         10             hello    world         \n         0         11           bonjour    monde         \n         0         12             hallo     welt         \n         1         10           goodbye    sweet   prince\n         1         11         au revoir     doux   prince\n         1         12   auf wiedersehen    süßer    prinz\n")
    end
  end

  describe "#fields" do
    it "returns the non-index columns" do
      expect(subject.fields).to eq(["word_1", "word_2", "word_3"])
    end
  end

  describe "#[]" do
    let(:result) { subject[slice] }

    context "when the argument is a string" do
      let(:slice) { "word_1" }

      it "slices out a property" do
        expect(result).to be_a(described_class)
        expect(result.indexes).to eq(indexes)
        expect(result.fields).to eq(["word_1"])
      end
    end

    context "when the argument is an array" do
      let(:slice) { ["word_1", "word_2"] }

      it "slices out a number of properties" do
        expect(result).to be_a(described_class)
        expect(result.indexes).to eq(indexes)
        expect(result.fields).to eq(["word_1", "word_2"])
      end
    end

    context "when the argument is a hash" do
      let(:slice) { { language: 10 } }

      it "drops the index" do
        expect(result).to be_a(described_class)
        expect(result.indexes).to eq(["sentence"])
        expect(result.size).to eq(2)
      end

      context "with multiple values" do
        let(:slice) { { language: [10, 11] } }

        it "keeps the index" do
          expect(result).to be_a(described_class)
          expect(result.indexes).to eq(["sentence", "language"])
          expect(result.size).to eq(4)
        end
      end

      context "with multiple indexes" do
        let(:slice) { { language: [10, 11], sentence: [0] } }

        it "slices correctly" do
          expect(result).to be_a(described_class)
          expect(result.indexes).to eq(["sentence", "language"])
          expect(result.size).to eq(2)
        end
      end
    end
  end

  describe "#size" do
    it "returns the number of tuples" do
      expect(subject.size).to eq(6)
    end
  end

  describe "#first" do
    context "without any arguments" do
      it "returns an instance with only the first row" do
        expect(subject.first.tuples).to eq([tuples[0]])
      end
    end

    context "with an argument" do
      it "returns the first N rows" do
        expect(subject.first(2).tuples).to eq(tuples[0..1])
      end
    end
  end

  describe "#members" do
    it "returns the members for an index key" do
      expect(subject.members("language")).to eq([10, 11, 12])
    end

    context "when a non-index key is provided" do
      it "raises an appropriate error" do
        expect { subject.members("word_1") }.to raise_error(ArgumentError, "TupleIndex#members only accepts index keys")
      end
    end
  end

end
