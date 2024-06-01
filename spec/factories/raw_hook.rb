FactoryBot.define do
  factory :raw_hook do
    headers { {"x-header-key" => "header-value"} }
    params { {"param-key" => "param-value"} }
    body { "payload" }
  end
end
