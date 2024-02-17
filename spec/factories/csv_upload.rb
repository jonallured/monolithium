FactoryBot.define do
  factory :csv_upload do
    data { "123,foo,true" }
    original_filename { "sample-data.csv" }
    parser_class_name { "SampleParser" }
  end
end
