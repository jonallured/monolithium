FactoryBot.define do
  factory :blog_post do
    number { 1 }
    published_on { Date.new(2007, 1, 1) }
    summary { "In this essay I will write." }
    title { "Very Long Essay" }
    url { "https://www.jonallured.com/posts/2007/01/01/very-long-essay.html" }
  end
end
