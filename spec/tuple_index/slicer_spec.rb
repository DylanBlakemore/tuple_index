RSpec.describe TupleIndex::Slicer do
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

  let(:indexes) { ["sentence", "language"] }

  describe ".slice_indexes" do
    let(:result) { TupleIndex::Slicer.slice_indexes(tuples, indexes, slice) }

    let(:expected_tuples) do
      [
        { "language" => 10, "word_1" => "hello", "word_2" => "world" },
        { "language" => 11, "word_1" => "bonjour", "word_2" => "monde" },
        { "language" => 12, "word_1" => "hallo", "word_2" => "welt"}
      ]
    end

    context "with a single index value" do
      let(:slice) { { sentence: 0 } }

      it "drops the index" do
        expect(result[0]).to match(expected_tuples)
        expect(result[1]).to match(["language"])
      end
    end

    context "with multiple index values" do
      let(:slice) { { language: [10, 12] } }

      let(:expected_tuples) do
        [
          { "sentence" => 0, "language" => 10, "word_1" => "hello", "word_2" => "world" },
          { "sentence" => 0, "language" => 12, "word_1" => "hallo", "word_2" => "welt"},
          { "sentence" => 1, "language" => 10, "word_1" => "goodbye", "word_2" => "sweet", "word_3" => "prince" },
          { "sentence" => 1, "language" => 12, "word_1" => "auf wiedersehen", "word_2" => "süßer", "word_3" => "prinz" }
        ]
      end

      it "keeps the index" do
        expect(result[0]).to match(expected_tuples)
        expect(result[1]).to match(["sentence", "language"])
      end
    end

    context "with multiple indexes" do
      let(:slice) { { language: [10, 12], sentence: 0 } }

      let(:expected_tuples) do
        [
          { "language" => 10, "word_1" => "hello", "word_2" => "world" },
          { "language" => 12, "word_1" => "hallo", "word_2" => "welt"}
        ]
      end

      it "slices correctly" do
        expect(result[0]).to match(expected_tuples)
        expect(result[1]).to match(["language"])
      end
    end
  end

  describe ".slice_fields" do
    let(:result) { TupleIndex::Slicer.slice_fields(tuples, indexes, slice) }

    let(:expected_tuples) do
      [
        { "sentence" => 0, "language" => 10, "word_1" => "hello", "word_2" => "world" },
        { "sentence" => 0, "language" => 11, "word_1" => "bonjour", "word_2" => "monde" },
        { "sentence" => 0, "language" => 12, "word_1" => "hallo", "word_2" => "welt"},
        { "sentence" => 1, "language" => 10, "word_1" => "goodbye", "word_2" => "sweet" },
        { "sentence" => 1, "language" => 11, "word_1" => "au revoir", "word_2" => "doux" },
        { "sentence" => 1, "language" => 12, "word_1" => "auf wiedersehen", "word_2" => "süßer" }
      ]
    end

    let(:slice) { ["word_1", "word_2"] }

    it "returns the requested fields" do
      expect(result[0]).to match(expected_tuples)
      expect(result[1]).to match(indexes)
    end
  end

  describe ".slice_field" do
    let(:result) { TupleIndex::Slicer.slice_field(tuples, indexes, slice) }

    let(:expected_tuples) do
      [
        { "sentence" => 0, "language" => 10, "word_1" => "hello" },
        { "sentence" => 0, "language" => 11, "word_1" => "bonjour" },
        { "sentence" => 0, "language" => 12, "word_1" => "hallo"},
        { "sentence" => 1, "language" => 10, "word_1" => "goodbye" },
        { "sentence" => 1, "language" => 11, "word_1" => "au revoir" },
        { "sentence" => 1, "language" => 12, "word_1" => "auf wiedersehen" }
      ]
    end

    let(:slice) { "word_1" }

    it "returns the requested field" do
      expect(result[0]).to match(expected_tuples)
      expect(result[1]).to match(indexes)
    end
  end
end
