class RawHook < ApplicationRecord
  validates_presence_of :body, :headers, :params

  has_one :hook, dependent: :destroy

  after_create_commit :created

  def self.permitted_params
    [
      :body,
      :headers,
      :params
    ]
  end

  def table_attrs
    [
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end

  private

  def created
    ParseRawHookJob.perform_later(id)
  end
end
