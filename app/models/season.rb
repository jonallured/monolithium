class Season < ActiveRecord::Base
  has_many :weeks, dependent: :destroy
  has_many :characters, dependent: :destroy

  def self.current
    order(:id).last
  end
end
