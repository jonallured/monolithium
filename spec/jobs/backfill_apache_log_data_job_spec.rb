require "rails_helper"

describe BackfillApacheLogDataJob do
  it "enqueues jobs in the range of the first day to the as of day" do
    as_of = BackfillApacheLogDataJob.first_day + 9.days
    BackfillApacheLogDataJob.perform_now(as_of)
    expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq 10
  end
end
