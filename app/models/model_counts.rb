class ModelCounts
  def self.calculate
    Rails.application.eager_load!
    klasses = ApplicationRecord.descendants.map(&:to_s).sort
    klasses.each_with_object({}) do |klass, memo|
      memo[klass] = klass.constantize.count
    end
  end
end
