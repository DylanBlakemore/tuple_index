RSpec.describe TupleIndex::Formatter do
  
  subject { described_class.new(tuples, indexes, fields) }

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
  let(:fields) { ["word_1", "word_2", "word_3"] }

  let(:expected_string) do
    "\n                                 word_1   word_2   word_3\n  sentence   language                                    \n         0         10             hello    world         \n         0         11           bonjour    monde         \n         0         12             hallo     welt         \n         1         10           goodbye    sweet   prince\n         1         11         au revoir     doux   prince\n         1         12   auf wiedersehen    süßer    prinz\n"
  end

  it "correctly formats the table" do
    expect(subject.table).to eq(expected_string.to_s)
  end
  
end
