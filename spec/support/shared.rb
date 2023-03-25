shared_context "admin password matches" do
  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:session_password_matches?).and_return(true)
  end
end
