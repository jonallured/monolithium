FactoryBot.define do
  factory :killswitch do
    bad_builds { [0] }
    minimum_build { 1 }
  end
end
