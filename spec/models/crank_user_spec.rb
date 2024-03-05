require "rails_helper"

describe CrankUser do
  describe ".new_with_code" do
    let!(:existing_crank_user) do
      CrankUser.create(code: "existing code")
    end

    context "unique code on first try" do
      let(:codes) do
        [
          "unique code"
        ]
      end

      it "is valid" do
        expect(SecureRandom).to receive(:hex).with(4).exactly(1).and_return(*codes)
        crank_user = CrankUser.new_with_code

        expect(crank_user).to be_valid
        expect(crank_user.code).to eq "unique code"
      end
    end

    context "unique code on second try" do
      let(:codes) do
        [
          "existing code",
          "unique code"
        ]
      end

      it "is valid" do
        expect(SecureRandom).to receive(:hex).with(4).exactly(2).and_return(*codes)
        crank_user = CrankUser.new_with_code

        expect(crank_user).to be_valid
        expect(crank_user.code).to eq "unique code"
      end
    end

    context "unique code on third try" do
      let(:codes) do
        [
          "existing code",
          "existing code",
          "unique code"
        ]
      end

      it "is valid" do
        expect(SecureRandom).to receive(:hex).with(4).exactly(3).and_return(*codes)
        crank_user = CrankUser.new_with_code

        expect(crank_user).to be_valid
        expect(crank_user.code).to eq "unique code"
      end
    end

    context "fails to find unique code" do
      let(:codes) do
        [
          "existing code",
          "existing code",
          "existing code"
        ]
      end

      it "is not valid" do
        expect(SecureRandom).to receive(:hex).with(4).exactly(3).and_return(*codes)
        crank_user = CrankUser.new_with_code

        expect(crank_user).to_not be_valid
        expect(crank_user.code).to eq nil
      end
    end
  end
end
