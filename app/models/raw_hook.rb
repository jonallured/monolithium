class RawHook < ApplicationRecord
  has_one :hook, dependent: :destroy

  after_create_commit :created

  private

  def created
    ParseRawHookJob.perform_later(id)
  end
end
