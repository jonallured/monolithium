class ApacheLogFile < ApplicationRecord
  STATES = %w[pending extracted transformed loaded]

  has_many :apache_log_items, dependent: :destroy

  has_object :extractor
  has_object :transformer

  validates :dateext, presence: true
  validates :state, inclusion: {in: STATES}

  def pending?
    state == "pending"
  end

  def extracted?
    state == "extracted"
  end

  def transformed?
    state == "transformed"
  end

  def loaded?
    state == "loaded"
  end

  def starting_s3_key
    "domino/logs/access.log-#{dateext}.gz"
  end
end
