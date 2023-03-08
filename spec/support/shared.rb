shared_context "admin password matches" do
  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:session_password_matches?).and_return(true)
  end
end

shared_context "skip book enhances" do
  before do
    allow(OpenLibrary).to receive(:get_book).and_return(nil)
  end
end
