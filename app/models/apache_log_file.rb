class ApacheLogFile < ApplicationRecord
  STATES = %w[pending extracted transformed loaded]

  has_many :apache_log_items, dependent: :destroy

  has_object :extractor
  has_object :transformer
  has_object :loader

  validates :dateext, presence: true
  validates :state, inclusion: {in: STATES}

  def self.import(dateext)
    apache_log_file = create(dateext: dateext, state: "pending")
    apache_log_file.extractor.run
    apache_log_file.transformer.run
    apache_log_file.loader.run
    apache_log_file
  end

  def self.permitted_params
    [
      :dateext,
      :parsed_entries,
      :raw_lines,
      :state
    ]
  end

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

  def s3_keys
    {
      access_log: "domino/logs/access.log-#{dateext}.gz",
      error_log: "domino/logs/error.log-#{dateext}.gz"
    }
  end

  def table_attrs
    [
      ["dateext", dateext],
      ["State", state],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
