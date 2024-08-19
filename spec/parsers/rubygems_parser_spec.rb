require "rails_helper"

describe RubygemsParser do
  let(:raw_hook) do
    FactoryBot.create(
      :raw_hook,
      headers: {"HTTP_AUTHORIZATION" => auth_header},
      params: {name: gem_name, version: gem_version}
    )
  end

  describe ".can_parse?" do
    let(:auth_header) { "shhh" }
    let(:gem_name) { "fancy_gem" }
    let(:gem_version) { "0.0.1" }

    context "with a RawHook record that does not have an auth header" do
      let(:auth_header) { nil }

      it "returns false" do
        expect(RubygemsParser.can_parse?(raw_hook)).to eq false
      end
    end

    context "with a RawHook record that does not have a name param" do
      let(:gem_name) { nil }

      it "returns false" do
        expect(RubygemsParser.can_parse?(raw_hook)).to eq false
      end
    end

    context "with a RawHook record that does not have a version param" do
      let(:gem_version) { nil }

      it "returns false" do
        expect(RubygemsParser.can_parse?(raw_hook)).to eq false
      end
    end

    context "with a RawHook record that has required info" do
      it "returns true" do
        expect(RubygemsParser.can_parse?(raw_hook)).to eq true
      end
    end
  end

  describe ".valid_for?" do
    let(:gem_name) { "fancy_gem" }
    let(:gem_version) { "0.0.1" }

    before do
      allow(Monolithium.config).to receive(:rubygems_api_key).and_return("shhh")
    end

    context "with an invalid signature" do
      let(:auth_header) { "invalid" }

      it "returns false" do
        expect(RubygemsParser.valid_for?(raw_hook)).to eq false
      end
    end

    context "with a valid signature" do
      let(:auth_header) do
        payload = [gem_name, gem_version, "shhh"].join
        Digest::SHA2.hexdigest(payload)
      end

      it "returns true" do
        expect(RubygemsParser.valid_for?(raw_hook)).to eq true
      end
    end
  end

  describe ".parse" do
    let(:auth_header) { "shhh" }
    let(:gem_name) { "fancy_gem" }
    let(:gem_version) { "0.0.1" }

    it "creates and returns a Hook record with a message" do
      hook = RubygemsParser.parse(raw_hook)
      expect(hook.message).to eq "published fancy_gem 0.0.1"
    end
  end
end
