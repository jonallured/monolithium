class WebhookSender < ApplicationRecord
  has_many :hooks
  validates :name, presence: true
  validates :parser, presence: true

  def self.permitted_params
    [
      :name,
      :parser
    ]
  end

  def self.circle
    find_by(name: "Circle CI")
  end

  def self.github
    find_by(name: "GitHub")
  end

  def self.heroku
    find_by(name: "Heroku")
  end

  def self.rubygems
    find_by(name: "RubyGems.org")
  end

  def handle(raw_hook)
    parser_klass = parser.constantize
    parser_klass.check_and_maybe_parse(raw_hook)
  end

  def logo_name
    "logos/#{name.delete(" .").downcase}-logo@2x.png"
  end

  def table_attrs
    [
      ["Name", name],
      ["Parser", parser],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
