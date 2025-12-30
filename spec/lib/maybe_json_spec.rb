require "rails_helper"

describe MaybeJson do
  describe ".parse" do
    let(:result) { MaybeJson.parse(source) }

    context "when source is nil" do
      let(:source) { nil }

      it "returns nil" do
        expect(result).to be_nil
      end
    end

    context "when source is empty string" do
      let(:source) { "" }

      it "returns nil" do
        expect(result).to be_nil
      end
    end

    context "when source is invalid" do
      let(:source) { "invalid" }

      it "returns nil" do
        expect(result).to be_nil
      end
    end

    context "when source is valid" do
      let(:source) { '{"foo":"bar"}' }

      it "parses source" do
        expect(result).to eq({"foo" => "bar"})
      end
    end

    context "with some options" do
      it "passes those options along" do
        source = '{"foo":"bar"}'
        opts = {symbolize_names: true}
        expect(JSON).to receive(:parse).with(source, opts).and_call_original
        result = MaybeJson.parse(source, opts)
        expect(result).to eq({foo: "bar"})
      end
    end
  end
end
