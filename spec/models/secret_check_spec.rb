require "rails_helper"

describe SecretCheck do
  describe ".match?" do
    it "is true when the values are the same" do
      expect(SecretCheck.match?("shhh", "shhh")).to eq true
    end

    it "is false when the values are different" do
      expect(SecretCheck.match?("shhh", "nope")).to eq false
    end

    it "is false when the values are different lengths" do
      expect(SecretCheck.match?("shhh", "shhhh")).to eq false
    end

    it "is false when both values are nil" do
      expect(SecretCheck.match?(nil, nil)).to eq false
    end

    it "is false when both values are empty" do
      expect(SecretCheck.match?("", "")).to eq false
    end

    it "is false when the actual value is not a string" do
      expect(SecretCheck.match?("shhh", ["shhh"])).to eq false
    end
  end

  describe ".digest" do
    it "does not return the value" do
      expect(SecretCheck.digest("shhh")).not_to include "shhh"
    end

    it "returns the same digest for the same value" do
      expect(SecretCheck.digest("shhh")).to eq SecretCheck.digest("shhh")
    end

    it "returns a different digest for a different value" do
      expect(SecretCheck.digest("shhh")).not_to eq SecretCheck.digest("nope")
    end

    it "returns nil for nil" do
      expect(SecretCheck.digest(nil)).to be_nil
    end

    it "returns nil for an empty string" do
      expect(SecretCheck.digest("")).to be_nil
    end
  end
end
