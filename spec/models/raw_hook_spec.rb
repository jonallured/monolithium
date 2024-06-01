require "rails_helper"

describe RawHook do
  describe "validation" do
    context "without required attrs" do
      it "is invalid" do
        raw_hook = RawHook.new
        expect(raw_hook).to_not be_valid
      end
    end

    context "with required attrs" do
      it "is valid" do
        raw_hook = RawHook.new(
          body: "foo",
          headers: {foo: :bar},
          params: {foo: :bar}
        )

        expect(raw_hook).to be_valid
      end
    end
  end
end
