require "rails_helper"

describe MarketingCollections do
  describe ".load_artworks" do
    let(:slugs) { %w[mock-slug] }
    let(:mock_response) { double(:mock_response, to_h: mock_data) }

    before do
      expect(MetaphysicsApi).to receive(:marketing_collection)
        .with("mock-slug")
        .and_return(mock_response)
    end

    context "with an empty api response" do
      let(:mock_data) { {} }

      it "does nothing" do
        expect(Artwork).to_not receive(:pluck).with(:gravity_id)

        expect do
          MarketingCollections.load_artworks(slugs)
        end.to_not change(Artwork, :count)
      end
    end

    context "with an api response that has existing artworks" do
      let(:artwork) { FactoryBot.create(:artwork) }

      let(:node_data) do
        {
          "gravity_id" => artwork.gravity_id
        }
      end

      let(:mock_data) do
        {
          "marketingCollection" => {
            "artworksConnection" => {
              "edges" => [
                {"node" => node_data}
              ]
            }
          }
        }
      end

      it "does nothing" do
        expect do
          MarketingCollections.load_artworks(slugs)
        end.to_not change(Artwork, :count)
      end
    end

    context "with an api response that has new artwork data" do
      let(:node_data) do
        {
          "gravity_id" => "new_gravity_id"
        }
      end

      let(:mock_data) do
        {
          "marketingCollection" => {
            "artworksConnection" => {
              "edges" => [
                {"node" => node_data}
              ]
            }
          }
        }
      end

      it "creates an Artwork record" do
        expect do
          MarketingCollections.load_artworks(slugs)
        end.to change(Artwork, :count).by(1)

        new_artwork = Artwork.last
        expect(new_artwork.gravity_id).to eq "new_gravity_id"
      end
    end
  end
end
