require "rails_helper"

describe SecretCheck do
  describe ".match?" do
    context "when the expected value is empty" do
      it "returns false" do
        expect(SecretCheck.match?("", "")).to eq false
      end
    end

    context "when the actual value is not a string" do
      it "returns false" do
        expect(SecretCheck.match?("shhh", ["shhh"])).to eq false
      end
    end

    context "when the values do not match" do
      it "returns false" do
        expect(SecretCheck.match?("shhh", "invalid")).to eq false
      end
    end

    context "when the values match" do
      it "returns true" do
        expect(SecretCheck.match?("shhh", "shhh")).to eq true
      end
    end
  end

  describe ".digest" do
    context "when the value is blank" do
      it "returns nil" do
        expect(SecretCheck.digest("")).to be_nil
      end
    end

    context "when the value is valid" do
      it "returns the digest" do
        expected = OpenSSL::HMAC.hexdigest("SHA256", Rails.application.secret_key_base, "shhh")

        expect(SecretCheck.digest("shhh")).to eq expected
      end
    end
  end
end
