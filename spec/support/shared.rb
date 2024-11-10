shared_context "admin password matches" do
  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:session_password_matches?).and_return(true)
  end
end

shared_context "pdf inspection" do
  let(:inspector) { PDF::Inspector::Page.analyze(daily_packet.pdf_data) }

  let(:page_one_strings) do
    page = inspector.pages[0]
    return unless page
    page[:strings]
  end

  let(:page_two_strings) do
    page = inspector.pages[1]
    return unless page
    page[:strings]
  end

  let(:page_three_strings) do
    page = inspector.pages[2]
    return unless page
    page[:strings]
  end

  let(:page_four_strings) do
    page = inspector.pages[3]
    return unless page
    page[:strings]
  end
end
