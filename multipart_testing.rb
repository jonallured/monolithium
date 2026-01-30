require "faraday"
require "faraday/multipart"

token = "0ce097f2352c15903180ee3d463f6fb9e0ff7f8209f9260b1a7ba8c5c18930c4ed76da28f6c614558f6518c7faf9b94099451e08d416352f374eded226eaddf6"
base_url = "http://localhost:3007"
headers = {"X-MLI-CLIENT-TOKEN" => token}

connection = Faraday.new(url: base_url, headers: headers) do |f|
  f.adapter Faraday.default_adapter
  # f.request :json
  f.request :multipart
  f.response :json
end

post_bin_endpoint = "/api/v1/post_bin"
file_part = Faraday::Multipart::FilePart.new("README.md", "text/plain")
params = {
  warm_fuzzy: {
    author: "Your medium-est fan",
    file: file_part,
    title: "You are ok"
  }
}
response = connection.post(post_bin_endpoint, params)

puts response.status
