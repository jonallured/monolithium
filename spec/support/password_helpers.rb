shared_context "session password matches" do
  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:session_password_matches?).and_return(true)
  end
end

shared_examples "admin password required" do |parameter|
  let(:path) { parameter }

  scenario "redirected to sign in" do
    visit path
    expect(current_path).to eq sign_in_path
  end
end
