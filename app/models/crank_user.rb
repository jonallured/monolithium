class CrankUser < ApplicationRecord
  validates :code, presence: true, uniqueness: true

  def self.generate_codes
    3.times.lazy.map do
      candidate = SecureRandom.hex(4)
      candidate unless CrankUser.where(code: candidate).exists?
    end.compact
  end

  def self.new_with_code
    code = generate_codes.first
    new(code: code)
  end

  def to_param
    code
  end
end
